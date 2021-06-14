module Extensions
  module Bulkrax
    module Importer
      module Mapping
        # If field_mapping is empty, setup a default based on the export_properties
        def mapping
          @mapping ||= if self.field_mapping.blank? || self.field_mapping == [{}]
                         if parser.import_fields.present? || self.field_mapping == [{}]
                           ActiveSupport::HashWithIndifferentAccess.new(
                             parser.import_fields.reject(&:nil?).map do |m|
                               Bulkrax.default_field_mapping.call(m)
                             end.inject(:merge)
                           )
                         end
                       else
                         self.field_mapping
                       end
        end
      end
    end
  end
end
