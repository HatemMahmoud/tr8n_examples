class User < ActiveRecord::Base
  
  def guest?
    id.blank?
  end
  
  def admin?
    true
  end
  
  def name
    [first_name, last_name].join(" ")
  end
end
