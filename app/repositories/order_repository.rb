require 'csv'
require_relative '../models/order'

class OrderRepository
  def initialize(orders_csv_path, meal_repository, customer_repository, employee_repository)
    # [...]
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @orders_csv_path = orders_csv_path
    @orders = []
    @next_id = 1
    load_csv if File.exist?(@orders_csv_path)
  end

  def create(order)
    order.id = @next_id
    @orders << order
    @next_id += 1
    save_csv
  end

  def all
    @orders
  end

  def undelivered_orders
    @orders.reject { |order| order.delivered? }
  end

  def find(id)
    @orders.find { |order| order.id == id}
  end

  private

  def load_csv
    CSV.foreach(@orders_csv_path, headers: :first_row, header_converters: :symbol) do |row|
      # Convert the meal_id, customer_id, employee_id to an integer
      meal_id = row[:meal_id].to_i
      customer_id = row[:customer_id].to_i
      employee_id = row[:employee_id].to_i
      # Use now converted ids to retrieve the Meal, Customer and Employee in their respective repositories
      ordered_meal = @meal_repository.find(row[:meal_id].to_i)
      customer = @customer_repository.find(row[:customer_id].to_i)
      employee = @employee_repository.find(row[:employee_id].to_i)
      id = row[:id].to_i

      delivered = row[:delivered] == 'true'
      # if row[:delivered] == "true"
      #   delivered = true
      # else
      #   delivered = false
      # end

      # Create the Order instances from the parsed information (from "strings" in the csv, to ruby objects AKA integers, arrays, booleans, instances of meal, instances of customer, etc...)
      @orders << Order.new(id: id, meal: ordered_meal, customer: customer, employee: employee, delivered: delivered)
    end
    @next_id = @orders.last.id + 1 unless @orders.empty?
  end

  def save_csv
    CSV.open(@orders_csv_path, "wb") do |csv|
      csv << %w[id delivered meal_id customer_id employee_id]
      @orders.each do |order|
        csv << [order.id, order.delivered, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end
end
