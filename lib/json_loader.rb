require "json"

class JsonLoader
  def self.load(path)
    JSON.parse(File.read(path), symbolize_names: true)
  end
end
