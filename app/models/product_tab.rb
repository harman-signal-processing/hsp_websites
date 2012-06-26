class ProductTab
  attr_accessor :key, :count
  
  def initialize(key, count=0)
    @key = key
    @count = count
  end
  
end