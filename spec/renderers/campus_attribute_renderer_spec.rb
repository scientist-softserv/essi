require 'rails_helper'

RSpec.describe CampusAttributeRenderer do
  let(:value) { 'IUB' }
  let(:obj) {
    {
      id: 'IUB',
      term: 'IU Bloomington',
      active: true,
      url: 'https://www.indiana.edu',
      img_src: 'campuses/iub.jpg',
      img_alt: 'The Sample Gates at IU Bloomington'
    }
  }
  let(:value_html) { described_class.new(value).value_html }

  before do
    allow(CampusService).to receive(:find).with(value).and_return(obj)
  end

  describe "#value_html" do
    context "with a campus" do
      it "returns a blank string" do
        expect(value_html).to be_blank
      end
    end
  end
end
