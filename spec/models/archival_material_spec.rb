# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
require 'rails_helper'

RSpec.describe ArchivalMaterial do

  include_examples "MARC Relators"
  include_examples "PagedResource Properties"
  include_examples "ExtraLockable Behaviors" do
    let(:curation_concern) { FactoryBot.create(:archival_material) }
  end

  describe '#ocr_searchable?' do
    let(:work) { described_class.new(ocr_state: nil) }

    context "when ocr_state is searchable" do
      it 'is searchable' do
        work.ocr_state = 'searchable'
        expect(work).to be_ocr_searchable
      end
    end

    context "when ocr_state is suppressed" do
      it 'is not searchable' do
        work.ocr_state = 'suppressed'
        expect(work).not_to be_ocr_searchable
      end
    end

    context "when ocr_state is nil" do
      it 'is not searchable' do
        expect(work).not_to be_ocr_searchable
      end
    end
  end
end
