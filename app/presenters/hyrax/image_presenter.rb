# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure
  end
end
