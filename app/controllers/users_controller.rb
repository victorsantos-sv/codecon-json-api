require "sinatra/base"
require "json"

class UsersController < Sinatra::Base
    before do
        content_type :json
    end

    helpers do
        def store
            ::STORE
        end
    end

    get "/users" do
        store.all.to_json
    end

    get "/users/:id" do
        user = store.find_by_id(params[:id])
        halt 404 unless user
        user.to_json
    end

    post "/users" do
        payload = JSON.parse(request.body.read, symbolize_names: true)
        store.add(payload)
        status 201
        payload.to_json
    end
end
