FactoryBot.define do
  factory :bulkrax_importer_mets_xml, class: 'Bulkrax::Importer' do
    name { 'METS XML Import' }
    admin_set_id { 'MyString' }
    user { FactoryBot.build(:admin) }
    frequency { 'PT0S' }
    parser_klass { 'Bulkrax::MetsXmlParser' }
    limit { 10 }
    parser_fields { { 'import_file_path' => 'spec/fixtures/xml/mets.xml' } }
    field_mapping do
      {
        "source_identifier" => { from: ["identifier"] },
        "work_type" => 'PagedResource'
      }
    end
  end
end
