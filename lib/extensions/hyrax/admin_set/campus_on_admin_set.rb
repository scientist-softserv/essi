module Extensions
  module Hyrax
    module AdminSet
      module CampusOnAdminSet
        def self.included(base)
          base.class_eval do
            include ::ESSI::CampusMetadata
          end
        end
      end
    end
  end
end
