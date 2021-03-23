# ensure value for #last_run
module Extensions
  module Bulkrax
    module Importer
      module LastRun
        def last_run
          super
          @last_run ||= self.current_run
        end
      end
    end
  end
end
