class RushHourApp < Sinatra::Base
  post '/sources' do
    cs = ClientAnalyzer.new(params[:identifier], params[:rootUrl])
    cs.create_or_find_client
    status cs.status
    body cs.body
  end

  post '/sources/:identifier/data' do |identifier|
    client = Client.where(identifier: identifier)
    if client.empty?
      status 403
      body "The client #{identifier} has not been registered with the application."
    else
      id = client[0].id
      payload = PayloadAnalyzer.new(params[:payload], id)
      status payload.status
      body payload.body
    end
  end

  get '/sources/:identifier' do |identifier|
    client = Client.where(identifier: identifier)
    if client.empty?
      status 403
      body "The Client with identifier '#{identifier}' doesn't exist"
    else
      requests = PayloadRequest.where(client_id: client[0].id)
      if requests.empty?
        status 403
        body "No data has been provided for this client"
      else
        @identifier = client[0].identifier
        @average_response = client[0].avg_response_time
        @max_response = client[0].max_response_time
        @min_response = client[0].min_response_time
        @request_type = client[0].frequent_request_type
        @all_verbs = client[0].list_of_verbs
        # @urls_ordered = client[0].ordered_urls
        @browsers = client[0].browsers
        @operating_systems = client[0].operating_systems
        @resolutions = client[0].screen_resolutions
        erb :index
      end
    end
  end
end
