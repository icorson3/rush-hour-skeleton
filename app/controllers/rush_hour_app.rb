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
        @client = client[0]
        @all_urls = @client.find_all_urls
        erb :index
      end
    end
  end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.where(identifier: identifier)[0]
      @u = @client.find_specific_url(relative_path)
      if @u.nil?
        status 403
        body "The Url with path #{relative_path} doesn't exist"
      else
        @url_id = Url.where(url: @u)[0]

        erb :show
      end
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      client = Client.where(identifier: identifier)[0]
      @hours = client.find_payloads_by_event_name(event_name)
      @event_name = event_name
      erb :events
    end
end
