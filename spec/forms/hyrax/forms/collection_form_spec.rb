require 'rails_helper'

RSpec.describe Hyrax::Forms::CollectionForm do
  let(:collection) { FactoryBot.build(:collection_lw) }
  let(:ability) { Ability.new(FactoryBot.create(:user)) }
  let(:repository) { double }
  let(:form) { described_class.new(collection, ability, repository) }
  let(:banner) do
    CollectionBrandingInfo.new(
      collection_id: '1',
      filename: 'banner.png',
      role: 'banner',
      image_path: '/fake/path/to/banner'
    )
  end
  let(:logo) do
    CollectionBrandingInfo.new(
      collection_id: '1',
      filename: 'logo.png',
      role: 'logo',
      alt_txt: '',
      target_url: '',
      image_path: '/fake/path/to/banner'
    )
  end

  describe "#banner_branding" do
    it "delegates to the model" do
      expect(form.model).to receive(:banner_branding)
      form.banner_branding
    end
 end

  describe "#logo_branding" do
    it "delegates to the model" do
      expect(form.model).to receive(:logo_branding)
      form.logo_branding
    end
  end

  describe "#banner_info" do
    context "without banners present" do
      it "returns an empty hash" do
        expect(form.banner_info).to be_a Hash
        expect(form.banner_info).to be_empty
      end
    end
    context "with banners present" do
      before do
        allow(collection).to receive(:banner_branding).and_return([banner])
      end
      it "returns a hash" do
        expect(form.banner_info).to be_a Hash
        expect(form.banner_info).not_to be_empty
      end
    end
  end

  describe "#logo_info" do
    context "without logos present" do
      it "returns an empty array" do
        expect(form.logo_info).to be_empty
      end
    end
    context "with logos present" do
      before do
        allow(collection).to receive(:logo_branding).and_return([logo])
      end
      it "returns an array of display_hash values" do
        expect(form.logo_info).to be_a Array
        expect(form.logo_info).not_to be_empty
        expect(form.logo_info.first).to be_a Hash
      end
    end
  end
end
