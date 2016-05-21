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
        @average_response =
        erb :index
        body "Success"
      end
    end
  end
end
