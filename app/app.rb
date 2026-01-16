require "sinatra/base"
require "json"

require_relative "../lib/json_loader"
require_relative "../lib/memory_store"

require_relative "controllers/health_controller"
require_relative "controllers/users_controller"

data = JsonLoader.load("data/users.json")
STORE = MemoryStore.new(data)

class App < Sinatra::Base
  use HealthController
  use UsersController
end
