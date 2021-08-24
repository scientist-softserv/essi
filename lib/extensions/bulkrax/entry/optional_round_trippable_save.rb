# modified from bulkrax: skip redundant save, and make record update optional
module Extensions
  module Bulkrax
    module Entry
      module OptionalRoundTrippableSave
        # In order for the existing exported hyrax_record, to be updated by a re-import
        # we need a unique value in Bulkrax.system_identifier_field
        # add the existing hyrax_record id to Bulkrax.system_identifier_field
        def make_round_trippable
          return unless importerexporter.make_round_trippable
          values = hyrax_record.send(::Bulkrax.system_identifier_field.to_s).to_a
          return if values.include? hyrax_record.id
          values << hyrax_record.id
          hyrax_record.send("#{::Bulkrax.system_identifier_field}=", values)
          hyrax_record.save
        end
      end
    end
  end
end
