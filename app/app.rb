require "sinatra/base"
require "json"
require_relative "../lib/memory_store"

require_relative "controllers/health_controller"
require_relative "controllers/users_controller"

class App < Sinatra::Base
  configure do
    set :store, MemoryStore.new
  end

  use HealthController
  use UsersController
end
