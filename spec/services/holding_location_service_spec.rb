require 'rails_helper'

RSpec.describe HoldingLocationService do
  let(:service) { described_class }
  let(:api_config) { { url: 'https://iucat.iu.edu/api/library',
                       api_enabled: true } }

  let(:id) { 'B-WELLS' }
  let(:email) { 'libref@indiana.edu' }
  let(:label) { 'Bloomington - Herman B Wells Library' }
  let(:phone) { '(812) 855-0100' }

  context "with rights statements", vcr: { cassette_name: 'iucat_libraries_up', record: :new_episodes } do
    it "gets the email of a holding location" do
      allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_config)
      expect(service.find(id).fetch('email')).to eq(email)
    end

    it "gets the label of a holding location" do
      allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_config)
      expect(service.find(id).fetch('label')).to eq(label)
    end

    it "gets the phone number of a holding location" do
      allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_config)
      expect(service.find(id).fetch('phone')).to eq(phone)
    end
  end
end
