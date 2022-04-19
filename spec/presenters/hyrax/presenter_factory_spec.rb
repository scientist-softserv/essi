require 'rails_helper'

# Tests Extensions::Hyrax::PresenterFactory::SolrRowLimit
# Adapted from hyrax gem's presenter_factory_spec.rb
RSpec.describe Hyrax::PresenterFactory do
  describe "#build_for" do
    let(:presenter_class) { Hyrax::FileSetPresenter }

    subject { described_class.build_for(ids: ['12', '13'], presenter_class: presenter_class, presenter_args: nil) }

    context "when some ids are found in solr" do
      let(:results) { [{ "id" => "12" }, { "id" => "13" }] }

      it "has increased rows limit and has two results" do
        expect(ActiveFedora::SolrService.instance.conn).to receive(:post)
                                                             .with('select', data: { q: "{!terms f=id}12,13", rows: 5000, qt: 'standard' })
                                                             .and_return('response' => { 'docs' => results })
        expect(subject.size).to eq 2
      end
    end
  end
end
