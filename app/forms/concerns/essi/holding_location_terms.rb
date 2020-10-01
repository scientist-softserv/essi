module ESSI
  module HoldingLocationTerms
    extend ActiveSupport::Concern
    included do
      self.terms += [:holding_location]
    end
  end
end
