require "sinatra"
# require "sinatra-contrib"
require "sinatra/cookies"
require "json"

get '/ping.json' do
  content_type :json
  {
    cookies: cookies.to_hash
  }.to_json
end
