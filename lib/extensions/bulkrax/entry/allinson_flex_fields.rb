module Extensions
  module Bulkrax
    module Entry
      module AllinsonFlexFields
        def build_for_importer
          # Ensure loading of all flexible metadata properties for the imported work type
          try(:add_work_type)
          factory_class&.new
          super
        end
      end
    end
  end
end
