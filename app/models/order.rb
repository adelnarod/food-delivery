class Order
  attr_reader :meal, :customer, :employee
  attr_accessor :delivered, :id

  def initialize(attributes = {})
    @meal = attributes[:meal]
    @customer = attributes[:customer]
    @employee = attributes[:employee]
    @delivered = attributes[:delivered] || false
    @id = attributes[:id]
  end

  def delivered?
    @delivered
  end

  def deliver!
    @delivered = true
  end
end
