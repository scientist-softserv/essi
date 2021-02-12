# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  module Actors
    class ArchivalMaterialActor < Hyrax::Actors::BaseActor
      include ESSI::ApplyOCR
    end
  end
end
