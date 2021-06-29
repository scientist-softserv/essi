# modified Hyrax/Blacklight methods, to allow arbitrary number of rows, for ESSI-1361, collection thumbnail selection
module Extensions
  module Hyrax
    module CollectionMemberSearchBuilder
      module Rows
        def rows=(value)
          params_will_change!
          @rows = [value, 1].map(&:to_i).max
        end
    
        # @param [#to_i] value
        def rows(value = nil)
          if value
            self.rows = value
            return self
          end
          @rows ||= begin
            # user-provided parameters should override any default row
            r = [:rows, :per_page].map {|k| blacklight_params[k] }.reject(&:blank?).first
            r ||= blacklight_config.default_per_page
            r.nil? ? nil : [r, 1].map(&:to_i).max
          end
        end
      end
    end
  end
end
