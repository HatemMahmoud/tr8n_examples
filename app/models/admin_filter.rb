class AdminFilter < Wf::Filter

  def inner_joins
    [["User", :user_id]]
  end
      
end
