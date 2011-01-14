class Admin::UsersController < Admin::BaseController
  
  def index
    @users = User.filter(:params => params)
  end

end
