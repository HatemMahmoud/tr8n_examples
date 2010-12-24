class Admin::UsersController < Admin::BaseController
  
  layout 'admin'
  
  def index
    @users = User.filter(:params => params)
  end

end
