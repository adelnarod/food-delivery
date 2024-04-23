require_relative '../views/orders_view'
require_relative '../views/meals_view'
require_relative '../views/customers_view'
require_relative '../views/sessions_view'
require_relative '../models/order'


class OrdersController
  def initialize(meal_repository, customer_repository, employee_repository, order_repository)
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @order_repository = order_repository
    @sessions_view = SessionsView.new
    @orders_view = OrdersView.new
    @customers_view = CustomersView.new
    @meals_view = MealsView.new
  end

  def add
    @meals_view.display(@meal_repository.all)
    meal_index = @orders_view.ask_user_for("Meal Index").to_i - 1
    meal = @meal_repository.all[meal_index]

    @customers_view.display(@customer_repository.all)
    customer_index = @customers_view.ask_user_for("Choose Customer").to_i - 1
    customer = @customer_repository.all[customer_index]

    @sessions_view.display_employees(@employee_repository.all_riders)
    employee_index = @sessions_view.ask_user_for("Employee Index").to_i - 1
    employee = @employee_repository.all_riders[employee_index]

    order = Order.new(meal: meal, customer: customer, employee: employee)
    @order_repository.create(order)
  end

  def mark_as_delivered
    @sessions_view.display(@order_repository.undelivered_orders)
    index = @sessions_view.ask_user_for("Mark which order? [use index]").to_i - 1
    order = @order_repository.undelivered_orders[index]
    order.deliver!
  end

  def list_undelivered_orders
    @sessions_view.display(@order_repository.undelivered_orders)
  end
end
