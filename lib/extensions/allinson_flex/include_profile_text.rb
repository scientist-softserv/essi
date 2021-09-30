# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module IncludeProfileText
      def self.included(base)
        base.class_eval do
          # modified from allinson_flex: more specific messaging
          validates :name, :value, presence: { message: ->(object, data) do
            "required: name (#{object.name}) or value (#{object.value}) is missing"
            end
          }
        end
      end
    end
  end
end
