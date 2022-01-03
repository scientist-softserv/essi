require 'rails_helper'

RSpec.describe CoverPageGenerator do
  # FIXME: change resource to a SolrDocument after resolving dynamic indexing of ActiveTriples to Arrays
  let(:resource) { build(:paged_resource) }
  let(:service) { described_class.new(resource) }
  let(:pdf) { Prawn::Document.new }
  let(:rights_statements) { ["http://rightsstatements.org/vocab/NKC/1.0/",
                             "http://rightsstatements.org/vocab/NoC-NC/1.0/"] }

  describe '#apply' do
    context 'with a nil rights_statement' do
      before(:each) do
        allow(resource).to receive(:rights_statement).and_return(nil)
      end
      it 'processes without error' do
        expect { service.apply(pdf) }.not_to raise_error
      end
    end
    context 'with a String rights_statement' do
      before(:each) do
        allow(resource).to receive(:rights_statement).and_return(rights_statements.first)
      end
      it 'processes without error' do
        expect { service.apply(pdf) }.not_to raise_error
      end
    end
    context 'with an Array rights_statement' do
      before(:each) do
        allow(resource).to receive(:rights_statement).and_return(rights_statements)
      end
      it 'processes without error' do
        expect { service.apply(pdf) }.not_to raise_error
      end
    end
  end
end
