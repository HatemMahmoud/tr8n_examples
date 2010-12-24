class Admin::UsersController < AdminController
  
  def index
    @users = User.filter(:params => params)
  end

end
