# modified from bulkrax
module Extensions
  module Bulkrax
    module CsvEntry
      module AddFileMetadata
        # modified to add file metadata
        def add_file
          super
          add_file_metadata
        end

        def add_file_metadata
          case record['file_label']
          when String
            labels = record['file_label'].split(/\s*[;|]\s*/)
          when Array
            labels = record['file_label']
          else
            labels = []
          end
          self.parsed_metadata['file_metadata'] = labels.map { |label| { label: label } }
        end
      end
    end
  end
end
