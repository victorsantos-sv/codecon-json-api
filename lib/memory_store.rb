require "concurrent"

class MemoryStore
  def initialize(data = [])
    @data = Concurrent::Array.new(data)
  end

  def all
    @data
  end

  def add(item)
    @data << item
  end

  def find_by_id(id)
    @data.find { |i| i[:id] == id }
  end
end
