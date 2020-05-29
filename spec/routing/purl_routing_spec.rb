require 'rails_helper'

RSpec.describe "Purl Routing" do
  it "routes to the default action" do
    expect(get(default_purl_path(id: "1"))) \
      .to route_to controller: "purl", action: "default", id: "1"
  end
  it "routes to the formats action" do
    expect(get(formats_purl_path(id: "1"))) \
      .to route_to controller: "purl", action: "formats", id: "1"
  end
end
