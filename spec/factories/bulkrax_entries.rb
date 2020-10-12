# frozen_string_literal: true

FactoryBot.define do
  factory :bulkrax_entry, class: 'Bulkrax::Entry' do
    identifier { "MyString" }
    type { 'Bulkrax::Entry' }
    importerexporter { FactoryBot.build(:bulkrax_importer) }
    raw_metadata { "MyText" }
    parsed_metadata { "MyText" }
  end
end

