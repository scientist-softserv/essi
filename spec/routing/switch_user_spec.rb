require 'rails_helper'

RSpec.describe "Switch User Routing" do
  it "routes to the default controller and action" do
    expect(:get => "/users/sessions/log_in_as").to \
    route_to(controller: "users/sessions", action: "log_in_as")
  end
  it "routes to switch_user set_current_user action" do
    expect(get: "/switch_user").to \
    route_to(controller: "switch_user", action: "set_current_user")
  end
  it "routes to switch_user remember_user action" do
    expect(get: "/switch_user/remember_user").to \
    route_to(controller: "switch_user", action: "remember_user")
  end
end
