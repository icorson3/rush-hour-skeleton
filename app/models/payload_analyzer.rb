class PayloadAnalyzer
  attr_reader :payload, :client_id
  attr_accessor :status, :body

  def initialize(payload, client_id)
    @client_id = client_id
    @p = payload
    @status = 200
    @body = "Payload created successfully"
    check_if_payload_parameter_was_sent
  end

  def check_if_payload_parameter_was_sent
    if @p.nil?
      @status = 400
      @body = "Please send payload parameters with request."
    else
      @payload = JSON.parse(@p)
      populate_payload_requests
    end
  end

  def populate_urls
    Url.where(url: payload["url"]).first_or_create
  end

  def populate_references
    Reference.where(reference: payload["referredBy"]).first_or_create
  end

  def populate_request_types
    RequestType.where(request_type: payload["requestType"]).first_or_create
  end

  def populate_event_names
    EventName.where(event_name: payload["eventName"]).first_or_create
  end

  def populate_software_agents
    user_agents = UserAgent.parse(payload["userAgent"])
    SoftwareAgent.where(browser: user_agents.browser, os: user_agents.os).first_or_create
  end

  def populate_resolutions
    Resolution.where(resolution_width: payload["resolutionWidth"], resolution_height: payload["resolutionHeight"]).first_or_create
  end

  def populate_ip_addresses
    IpAddress.where(ip_address: payload["ip"]).first_or_create
  end

 def populate_payload_requests
   pr = PayloadRequest.new({
    url_id: populate_urls.id,
    requested_at: payload["requestedAt"],
    responded_in: payload["respondedIn"],
    reference_id: populate_references.id,
    request_type_id: populate_request_types.id,
    parameters: payload["parameters"],
    event_name_id: populate_event_names.id,
    software_agent_id: populate_software_agents.id,
    resolution_id: populate_resolutions.id,
    ip_address_id: populate_ip_addresses.id,
    client_id: client_id
   })
   pr.save
 end

 def payload_status
   if !populate_payload_requests
     if error_messages.include?("has already been taken")
       @status = 403
       @body = error_messages
     else
       @status = 400
       @body = error_messages
     end
   end
 end

 def error_messages
   populate_payload_requests.errors.full_messages.join(", ")
 end

end
