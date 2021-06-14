module Extensions
  module Bulkrax
    module Exporter
      module Mapping
        # If field_mapping is empty, setup a default based on the export_properties
        def mapping
          @mapping ||= self.field_mapping ||
                       ActiveSupport::HashWithIndifferentAccess.new(
                         export_properties.map do |m|
                           Bulkrax.default_field_mapping.call(m)
                         end.inject(:merge)
                       ) ||
                       [{}]
        end
      end
    end
  end
end
