class SessionsView
  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end

  def display(orders)
    orders.each_with_index do |order, index|
      puts "#{index + 1}. #{order.customer.name} - #{order.meal.name}   Rider: #{order.employee.username}"
    end
  end

  def display_employees(employees)
    employees.each_with_index do |employee, index|
      puts "#{index + 1}. #{employee.username} "
    end
  end

  def print_error
    puts "Username or Password wrong"
  end
end
