class RushHourApp < Sinatra::Base
  post '/sources' do
    cs = ClientAnalyzer.new(params[:identifier], params[:rootUrl])
    cs.create_or_find_client
    status cs.status
    body cs.body
  end

  post '/sources/:identifier/data' do |identifier|
    binding.pry
    client = Client.where(identifier: identifier)
    if client.empty?
      status 403
      body "The client #{identifier} has not been registered with the application." 
    else
      id = client[0].id
      payload = PayloadAnalyzer.new(params[:payload], id)
      payload.payload_status
      status payload.status
      body payload.body
    end
  end
end
