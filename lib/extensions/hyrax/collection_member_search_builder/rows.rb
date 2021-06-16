# unmodified Hyrax/Blacklight methods, prepping changes for ESSI-1361, collection thumbnail selection
module Extensions
  module Hyrax
    module CollectionMemberSearchBuilder
      module Rows
        def rows=(value)
          params_will_change!
          @rows = [value, blacklight_config.max_per_page].map(&:to_i).min
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
            # ensure we don't excede the max page size
            r.nil? ? nil : [r, blacklight_config.max_per_page].map(&:to_i).min
          end
        end
      end
    end
  end
end
