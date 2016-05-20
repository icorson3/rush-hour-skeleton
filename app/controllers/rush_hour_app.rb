class RushHourApp < Sinatra::Base
  post '/sources' do
    cs = ClientAnalyzer.new(params[:identifier], params[:rootUrl])
    cs.create_or_find_client
    status  cs.status
    body cs.body
  end
end
