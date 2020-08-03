require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  let(:solr_doc) { described_class.new(document_hash) }
  let(:document_hash) do
    {
      width_is: 200,
      height_is: 400
    }
  end
  let(:other_urls) { ['foo', 'bar'] }
  let(:catalog_url) { ESSI.config.dig(:essi, :metadata, :url).to_s % 'CATALOG_ID' }
  let(:related_url) { other_urls + [catalog_url] }

  describe "#height" do
    it "returns the height_is" do
      expect(solr_doc.height).to eq 400
    end
  end

  describe "#width" do
    it "returns the width_is" do
      expect(solr_doc.width).to eq 200
    end
  end

  describe "#related_url" do
    it "is an empty array by default" do
      expect(solr_doc.related_url).to eq []
    end
    context 'with values present' do
      before do
        document_hash['related_url_tesim'] = related_url
      end
      it 'shows non-catalog values' do
        expect(solr_doc.related_url).to eq other_urls
      end
    end
  end

  describe "#catalog_url" do
    it "is nil by default" do
      expect(solr_doc.catalog_url).to be_nil
    end
    context 'with values present' do
      before do
        document_hash['related_url_tesim'] = related_url
      end
      it 'shows catalog-specific value' do
        expect(solr_doc.catalog_url).to eq catalog_url
      end
    end
  end
end
