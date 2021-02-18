require 'rails_helper'

RSpec.describe ESSI::FileSetIndexer do
  subject(:solr_document) { service.generate_solr_document }
  let(:service) { described_class.new(file_set) }
  let(:file_set) { FactoryBot.create(:file_set) }

  context 'with a file' do
    let(:file_set) { FactoryBot.create(:file_set, content: File.open(RSpec.configuration.fixture_path + '/world.png')) }
    let(:file) { file_set.files.first }

    it 'indexes a IIIF thumbnail path' do
      expect(solr_document.fetch('thumbnail_path_ss')).to match "/iiif/2/#{CGI.escape(file.id)}/full/250,/0/default.jpg"
    end
  end
end
