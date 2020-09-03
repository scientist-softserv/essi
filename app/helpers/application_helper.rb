module ApplicationHelper
  def display_for(role_name)
    yield if current_user.roles.include? Role.where(name: role_name).first
  end

  def access_only?
    # Check to see if the running site should suppress admin and editor controls
    ESSI.config.dig(:essi, :site_usage) == 'access_only'
  end
end
