module ESSI
  module UniversityPlaceTerms
    extend ActiveSupport::Concern
    included do
      self.terms += [:university_place]
    end
  end
end
