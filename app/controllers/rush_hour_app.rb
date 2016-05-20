class RushHourApp < Sinatra::Base
  post '/sources' do
    cs = ClientAnalyzer.new(params[:identifier], params[:rootUrl])
    cs.create_or_find_client
    status cs.status
    body cs.body
  end

  post '/sources/:identifier/data' do |identifier|
    id = Client.where(identifier: identifier)[0].id
    payload = PayloadAnalyzer.new(params[:payload], id)

    status payload.status
    body payload.body
  end
end
