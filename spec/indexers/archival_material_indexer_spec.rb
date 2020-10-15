require 'rails_helper'

RSpec.describe ArchivalMaterialIndexer do
  subject(:solr_document) { service.generate_solr_document }
  let(:service) { described_class.new(work) }

  context 'with a file' do
    let(:work) { FactoryBot.create(:archival_material_with_one_image) }
    let(:file_set) { work.file_sets.first}
    let(:file) { file_set.original_file }

    it 'indexes a IIIF thumbnail path' do
      expect(solr_document.fetch('thumbnail_path_ss')).to eq "/iiif/2/#{CGI.escape(file.id)}/full/250,/0/default.jpg"
    end
  end
end
