class ClientAnalyzer
  attr_reader :identifier, :root_url
  attr_accessor :status, :body

  def initialize(identifier = nil, root_url = nil)
    @identifier = identifier
    @root_url = root_url
    @status = 200
    @body = "{'Identifier': '#{identifier}'}"
  end

  def create_or_find_client
    cs = Client.new(identifier: identifier, root_url: root_url)
    check_error_messages(cs) unless cs.save
  end

  def check_error_messages(client)
    if client.errors.full_messages.join(", ") == "Identifier has already been taken"
      @status = 403
      @body = "The client with identifier '#{identifier}' already exists."
    else
      @status = 400
      @body = client.errors.full_messages.join(", ")
    end
  end
end
