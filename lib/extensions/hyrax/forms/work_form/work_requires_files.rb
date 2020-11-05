# Add object-specific method for #work_requires_files?
module Extensions
  module Hyrax
    module Forms
      module WorkForm
        module WorkRequiresFiles
          def work_requires_files?
            ::Hyrax.config.work_requires_files?
          end
        end
      end
    end
  end
end
