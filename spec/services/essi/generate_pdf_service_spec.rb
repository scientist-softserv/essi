require 'rails_helper'


RSpec.describe ESSI::GeneratePdfService do
  let(:resource) { create(:paged_resource) }
  let(:service) { described_class.new(resource) }
  let(:pdf) { service.generate }

  before do
    pdf_tmps = Rails.root.join('spec', 'tmp', 'pdfs')
    allow_any_instance_of(described_class).to receive(:dir_path)
      .and_return(pdf_tmps)
  end

  describe '#generate' do
    it 'returns a hash with path and file name of the generated pdf document' do
      expect(service.generate).to eq({ file_path: pdf[:file_path],
                                       file_name: "#{resource.id}.pdf" })
    end
  end
end
