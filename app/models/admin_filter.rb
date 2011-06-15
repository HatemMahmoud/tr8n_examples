require 'will_filter'

class AdminFilter < WillFilter::Filter

  def inner_joins
    [["User", :user_id]]
  end
      
end
