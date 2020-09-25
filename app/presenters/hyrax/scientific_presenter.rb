# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  class ScientificPresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsHoldingLocation
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure
    include ESSI::PresentsCampus
  end
end
