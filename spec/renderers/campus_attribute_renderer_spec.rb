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
  let(:rendered) { described_class.new(value).render }

  before do
    allow(CampusService).to receive(:find).with(value).and_return(obj)
  end

  context "with a rendered campus" do
    it "renders the label and facet search link " do
      expect(rendered).to include('IU Bloomington')
      expect(rendered).to match /href=".*catalog.*campus_sim.*IUB/
    end
  end
end
