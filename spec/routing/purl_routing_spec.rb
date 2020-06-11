require 'rails_helper'

RSpec.describe "Purl Routing" do
  it "routes to the default action by source_metadata_identifier match" do
    expect(get(default_purl_path(id: "1"))) \
      .to route_to controller: "purl", action: "default", id: "1"
  end
  it "routes to the default action by identifier match" do
    expect(get("/purl/unit/collection/1")) \
      .to route_to controller: "purl", action: "default", id: "unit/collection/1"
  end
  it "routes to the formats action" do
    expect(get(formats_purl_path(id: "1"))) \
      .to route_to controller: "purl", action: "formats", id: "1"
  end
end
