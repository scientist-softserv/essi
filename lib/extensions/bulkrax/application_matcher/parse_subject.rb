module Extensions
  module Bulkrax
    module ApplicationMatcher
      module ParseSubject
        # Do not modify subject capitilization
        def parse_subject(src)
          string = src.strip.downcase
          return if string.blank?

          string
        end
      end
    end
  end
end
