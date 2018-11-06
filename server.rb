require "sinatra"
# require "sinatra-contrib"
require "sinatra/cookies"
require "json"

get '/ping.json' do
  content_type :json
  {
    headers: headers.to_hash,
    cookies: cookies.to_hash
  }.to_json
end
