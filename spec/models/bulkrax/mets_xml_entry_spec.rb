# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe MetsXmlEntry, type: :model do
    let(:path) { './spec/fixtures/xml/METADATA.xml' }
    let(:data) { described_class.read_data(path) }

    before do
      Bulkrax.source_identifier_field_mapping = { 'Bulkrax::MetsXmlEntry' => 'OBJID' }
    end

    describe 'class methods' do
      context '#read_data' do
        it 'reads the data from an xml file' do
          expect(data).to be_a(Nokogiri::XML::Document)
        end
      end

      context '#data_for_entry' do
        it 'retrieves the data and constructs a hash' do
          expect(described_class.data_for_entry(data.root)).to eq(
            source_identifier: 'http://purl.dlib.indiana.edu/iudl/archives/VAC1741-00310',
            data: open(path).read,
            collection: [],
            children: []
          )
        end
      end
    end

    describe '#build' do
      subject(:xml_entry) { described_class.new(importerexporter: importer) }
      let(:raw_metadata) { described_class.data_for_entry(data.root) }
      let(:importer) { FactoryBot.build(:bulkrax_importer_mets_xml) }
      let(:object_factory) { instance_double(ObjectFactory) }

      before do
        Bulkrax.default_work_type = 'Work'
        Bulkrax.source_identifier_field_mapping = { 'Bulkrax::MetsXmlEntry' => 'OBJID' }
        Bulkrax.field_mappings.merge!(
          'Bulkrax::XmlParser' => {
            "source_identifier" => { from: ["identifier"] },
            "work_type" => 'PagedResource',
            'abstract' => { from: ['Abstract'] }
          }
        )
      end

      context 'with raw_metadata' do
        before do
          xml_entry.raw_metadata = raw_metadata
          allow(ObjectFactory).to receive(:new).and_return(object_factory)
          allow(object_factory).to receive(:run!).and_return(instance_of(PagedResource))
          allow(User).to receive(:batch_user)
          VCR.use_cassette('mets_xml_entry_spec') do
            xml_entry.build
          end
        end

        it 'succeeds' do
          expect(xml_entry.status).to eq('Complete')
        end

        it 'builds entry' do
          expect(xml_entry.parsed_metadata).to include('admin_set_id' => 'MyString',
                                                       'rights_statement' => [nil],
                                                       'source' => ["http://purl.dlib.indiana.edu/iudl/archives/VAC1741-00310"],
                                                       'title' => ["http://purl.dlib.indiana.edu/iudl/archives/VAC1741-00310"],
                                                       #'viewing_direction' => 'left-to-right',
                                                       'visibility' => 'open',
                                                       'work_type' => ['PagedResource'])
          expect(xml_entry.parsed_metadata).to include('remote_files' => a_collection_starting_with(a_hash_including(:file_name => 'VAC1741-U-00064-001-thumbnail')),
                                                       'structure' => a_hash_including(:nodes))
        end

        it 'does not add unsupported fields' do
          expect(xml_entry.parsed_metadata).not_to include('abstract')
          expect(xml_entry.parsed_metadata).not_to include('Lorem ipsum dolor sit amet.')
        end
      end

      context 'without raw_metadata' do
        before do
          xml_entry.raw_metadata = nil
        end

        it 'fails' do
          xml_entry.build
          expect(xml_entry.status).to eq('Failed')
        end
      end
    end

    xit '#add_logical_structure' do
      # described_class.build_metadata
      logical_structure = described_class.parsed_metadata['structure']
      expect(logical_structure['label']).to eq('VAC1741-U-00064')
      expect(logical_structure['nodes'].first['proxy']).to eq('VAC1741-U-00064-001')
    end
  end
end
