# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'

RSpec.describe Hyrax::PagedResourcePresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:request) { double(host: 'example.org', base_url: 'http://example.org') }
  let(:user_key) { 'a_user_key' }
  let(:current_user) { create :admin }

  let(:attributes) do
    { "id" => '888888',
      "title_tesim" => ['foo', 'bar'],
      "human_readable_type_tesim" => ["Paged Resource"],
      "has_model_ssim" => ["PagedResource"],
      "date_created_tesim" => ['an unformatted date'],
      "depositor_tesim" => user_key }
  end
  let(:ability) { Ability.new(current_user) }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  subject { described_class.new(double, double) }

  describe "#manifest" do
    let(:work) { create(:paged_resource_with_one_image) }
    let(:solr_document) { SolrDocument.new(work.to_solr) }
    let(:pdf_rendering_hash) { 
      {
        "@id"=>"/concern/paged_resources/#{work.id}/pdf",
        "label"=>"Download as PDF",
        "format"=>"application/pdf"
      }
    }

    include_examples "pdf sequence rendering"
  end

  include_examples "presents related_url"
end
