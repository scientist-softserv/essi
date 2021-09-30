# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module IncludeProfileText
      def self.included(base)
        base.class_eval do
          # unmodified from allinson_flex
          validates :name, :value, presence: true
        end
      end
    end
  end
end
