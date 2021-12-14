module Extensions
  module Bulkrax
    module ApplicationMatcher
      module ParseSubject
        # unmodified bulkrax method
        def parse_subject(src)
          string = src.strip.downcase
          return if string.blank?

          string.slice(0, 1).capitalize + string.slice(1..-1)
        end
      end
    end
  end
end
