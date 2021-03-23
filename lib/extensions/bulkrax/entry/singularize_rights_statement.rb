# bulkrax always Array wraps rights_statement, which could be singular
module Extensions
  module Bulkrax
    module Entry
      module SingularizeRightsStatement
        def add_rights_statement
          super
          unless factory_class.properties.with_indifferent_access['rights_statement'].multiple?
            if self.parsed_metadata['rights_statement'].is_a?(Array)
              self.parsed_metadata['rights_statement'] = self.parsed_metadata['rights_statement'].first
            end
          end
        end
      end
    end
  end
end
