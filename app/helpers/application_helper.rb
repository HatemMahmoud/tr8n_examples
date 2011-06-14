# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Tr8n::HelperMethods
  include Wf::HelperMethods

  
  def display_user_tag(user)
    "#{user.name} (#{user.id})"
  end

end
