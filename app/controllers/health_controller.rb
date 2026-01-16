require "sinatra/base"

class HealthController < Sinatra::Base
  get "/health" do
    content_type :json
    { status: "ok" }.to_json
  end
end
