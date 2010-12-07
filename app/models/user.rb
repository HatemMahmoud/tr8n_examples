class User < ActiveRecord::Base
  
  def guest?
    id.blank?
  end
  
  def admin?
    true
  end
  
end
