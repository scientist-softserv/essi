module Extensions
  module Hyrax
    module Forms
      module AdminSetForm
        module CustomizedTerms
          def self.included(base)
            base.class_eval do
              self.terms = [:title, :description, :thumbnail_id]

              # Cast any array values on the model to scalars.
              def [](key)
                return super if key == :thumbnail_id
                super.first
              end

              class << self
                # This determines whether the allowed parameters are single or multiple.
                # By default it delegates to the model.
                def multiple?(_term)
                  false
                end
              end
            end
          end
        end
      end
    end
  end
end
