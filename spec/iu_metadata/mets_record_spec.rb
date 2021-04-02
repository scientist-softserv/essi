require 'rails_helper'

RSpec.describe IuMetadata::METSRecord do
  let(:fixture_path) { File.expand_path('../../fixtures', __FILE__) }
  let(:record1) {
    pth = File.join(fixture_path, 'iu_metadata/pudl0001-4609321-s42.mets')
    described_class.new('file://' + pth, open(pth))
  }
  let(:thumbnail_path) { "file:///users/escowles/downloads/tmp/00000001.tif" }

  record1_attributes =
    {
      "source_metadata_identifier" => 'bhr9405',
      "identifier" => 'ark:/88435/7d278t10z',
      "viewing_direction" => 'left-to-right'
    }

  describe "#attributes" do
    it "provides attibutes" do
      expect(record1.attributes).to eq record1_attributes
    end
  end

  describe "parses attributes" do
    record1_attributes.each do |att, val|
      describe "##{att}" do
        it "retrieves the correct value" do
          expect(record1.send(att)).to eq val
        end
      end
    end
  end

  describe "#final_url" do
    let(:thumbnail_xpath) { "/mets:mets/mets:fileSec/mets:fileGrp[@USE='thumbnail']/mets:file" }
    let(:file) { record1.instance_variable_get(:@mets).xpath(thumbnail_xpath).first }
    context "when a final redirect url is applicable" do
      let(:final_url) { 'http//final.url' }
      before { allow(IuMetadata::FinalRedirectUrl).to receive(:final_redirect_url).and_return(final_url) }
      it "returns the final redirect url" do
        expect(record1.send(:final_url, file)).to eq final_url
      end
    end
    context "when no final redirect url is applicable" do
      before { allow(IuMetadata::FinalRedirectUrl).to receive(:final_redirect_url).and_return(nil) }
      it "returns the final redirect url, inclusive of any initial file://" do
        expect(record1.send(:final_url, file)).to eq thumbnail_path
      end
    end
  end

  describe "#thumbnail_path" do
    it "returns the xlink:href value, retaining any 'file://' at the beginning" do
      expect(record1.thumbnail_path).to eq thumbnail_path
    end
  end
end
