# AdminSetForm in Hyrax presents multi-valued attributes as single-valued
# These modifications work around that workaround, as needed
module Extensions
  module Hyrax
    module Forms
      module AdminSetForm
        module CustomizedTerms
          def self.included(base)
            base.class_eval do
              self.terms = [:title, :description, :thumbnail_id, :university_place]
              class_attribute :allowed_array_terms
              self.allowed_array_terms = [:university_place]

              # Cast array values on the model to scalars, with exceptions
              def [](key)
                return super if key == :thumbnail_id
                return super if key.in? allowed_array_terms   
                super.first
              end

              class << self
                # Normally delegates to the model, but Hyrax overrides to return false
                # Modified to allow exceptions to carry through as true
                def multiple?(term)
                  term.in? allowed_array_terms
                end
              end
            end
          end
        end
      end
    end
  end
end
