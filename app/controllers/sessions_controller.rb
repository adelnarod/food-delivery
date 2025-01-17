require_relative '../views/sessions_view'

class SessionsController
  def initialize(employee_repository)
    @employee_repository = employee_repository
    @sessions_view = SessionsView.new
  end

  def login
    username = @sessions_view.ask_user_for("username")
    password = @sessions_view.ask_user_for("password")

    employee = @employee_repository.find_by_username(username)

    return employee if employee && employee.password == password

    @sessions_view.print_error
    login
  end
end
