# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe MetsXmlParser do
    describe '#create_works' do
      subject(:xml_parser) { described_class.new(importer) }
      let(:importer) { create(:bulkrax_importer_mets_xml) }
      let(:entry) { create(:bulkrax_entry, importerexporter: importer) }

      before do
        Bulkrax.default_work_type = 'Work'
        Bulkrax.source_identifier_field_mapping = { 'Bulkrax::MetsXmlEntry' => 'OBJID' }
        Bulkrax.field_mappings['Bulkrax::MetsXmlParser'] = {
          "source_identifier" => { from: ["identifier"] },
          "work_type" => 'PagedResource'
        }

        allow(Bulkrax::MetsXmlEntry).to receive_message_chain(:where, :first_or_create!).and_return(entry)
        allow(entry).to receive(:id)
        allow(Bulkrax::ImportWorkJob).to receive(:perform_later)
      end

      context 'with good data' do
        before do
          importer.parser_fields = {
            'import_file_path' => './spec/fixtures/xml/mets.xml',
            'record_element' => 'mets:mets'
          }
        end

        context 'and import_type set to single' do
          before do
            importer.parser_fields.merge!('import_type' => 'single')
          end

          it 'processes the line' do
            expect(xml_parser).to receive(:increment_counters).once
            xml_parser.create_works
          end

          it 'counts the correct number of works and collections' do
            expect(xml_parser.total).to eq(1)
            expect(xml_parser.collections_total).to eq(0)
          end
        end
      end
    end
  end
end
