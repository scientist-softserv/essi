# new method to ensure work type is set, to ensure allinson_flex properties are loaded
module Extensions
  module Bulkrax
    module CsvEntry
      module AddWorkType
        # modified from build_metadata method
        def add_work_type
          raise StandardError, 'Record not found' if record.nil?
          self.parsed_metadata ||= {}
          record.each do |key, value|
            next unless key == 'model'
    
            index = key[/\d+/].to_i - 1 if key[/\d+/].to_i != 0
            add_metadata(key_without_numbers(key), value, index)
          end
          self.parsed_metadata
        end
      end
    end
  end
end
