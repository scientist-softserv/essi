module ESSI
  module CampusTerms
    extend ActiveSupport::Concern
    included do
      self.terms += [:campus]
    end
  end
end
