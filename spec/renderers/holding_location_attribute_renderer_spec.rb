require 'rails_helper'

RSpec.describe HoldingLocationAttributeRenderer do
  let(:uri) { 'http://rightsstatements.org/vocab/InC/1.0/' }
  let(:obj) {
    {
      label: "Sample",
      phone: "123-456-7890",
      email: "ex@example.org",
      url: "https://bibdata.example.org/locations/delivery_locations/1.json",
      id: "https://bibdata.example.org/locations/delivery_locations/1",
      address: "Example Campus Delivery"
    }
  }
  let(:rendered) { described_class.new(uri).render }

  before do
    # HoldingLocationService holds a reference to an authority as a
    # module-level attribute.  Must stub it in case the module is already
    # initialized by a previous test.
    allow(HoldingLocationService).to receive(:find).and_return(obj)
  end

  context "with a rendered holding location" do
    it "renders the location label and email/phone links" do
      expect(rendered).to include('Sample')
      expect(rendered).to include('ex@example.org')
      expect(rendered).to include('123-456-7890')
      expect(rendered).to include('Example Campus')
    end
  end
end
