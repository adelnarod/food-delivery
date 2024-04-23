class Router
  def initialize(meals_controller, customers_controller, sessions_controller, orders_controller)
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
    @orders_controller = orders_controller
    @running = true
  end

  def run
    while @running
      @current_user = @sessions_controller.login
      while @current_user
        if @current_user.manager?
          route_manager_action
        else
          route_rider_action
        end
      end
      print `clear`
    end
  end

  private

  def print_menu_manager
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. Add new meal"
    puts "2. List all meals"
    puts "3. Add new customer"
    puts "4. List all customers"
    puts "5. Place order"
    puts "6. Undelivered Orders"
    puts "8. Exit"
    print "> "
  end

  def print_menu_rider
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List undelivered orders"
    puts "2. Mark order as delivered"
    puts "8. Exit"
    print "> "
  end

  def route_manager_action
    print_menu_manager
    choice = gets.chomp.to_i
    case choice
    when 1 then @meals_controller.add
    when 2 then @meals_controller.list
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.add
    when 6 then @orders_controller.list_undelivered_orders

    when 8 then stop!
    else puts "Try again..."
    end
  end

  def route_rider_action
    print_menu_rider
    choice = gets.chomp.to_i
    case choice
    when 1 then @orders_controller.list_undelivered_orders
    when 2 then @orders_controller.mark_as_delivered
    when 8 then stop!
    else puts "Try again..."
    end
  end

  def stop!
    @running = false
    @current_user = nil
  end
end
