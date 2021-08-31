module Extensions
  module Bulkrax
    module ApplicationParser
      module IdentifierHash
        # unmodified bulkrax method
        def identifier_hash
          @identifier_hash ||= importerexporter.mapping.select do |_, h|
            h.key?("source_identifier")
          end
          raise StandardError, "more than one source_identifier declared: #{@identifier_hash.keys.join(', ')}" if @identifier_hash.length > 1
    
          @identifier_hash
        end
      end
    end
  end
end
