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
        @all_urls = client[0].find_all_urls
        @average_response = client[0].avg_response_time
        @max_response = client[0].max_response_time
        @min_response = client[0].min_response_time
        @request_type = client[0].frequent_request_type
        @all_verbs = client[0].list_of_verbs
        @urls_ordered = client[0].ordered_urls
        @browsers = client[0].browsers
        @operating_systems = client[0].operating_systems
        @resolutions = client[0].screen_resolutions
        erb :index
      end
    end
  end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.where(identifier: identifier)[0]
      @u = @client.find_specific_url(relative_path)
      @url_id = Url.where(url: @u)[0]
      if @u.nil?
        status 403
        body "The Url with path #{relative_path} doesn't exist"
      else
        @url_max = @url_id.max_response_time
        @url_min = @url_id.min_response_time
        @url_times = @url_id.all_response_times
        @url_average = @url_id.average_response_time
        @url_verbs = @url_id.all_http_verbs
        @url_referrers = @url_id.top_three_referrers
        @url_agents = @url_id.top_three_user_agents
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
