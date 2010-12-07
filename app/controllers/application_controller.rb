# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include Tr8n::CommonMethods

  def current_user
    User.new
  end
  helper_method :current_user

  def login!(user)
    session[:user_id] = user.id
  end

  def logout!
    session[:user_id] = nil
  end  
  
end
