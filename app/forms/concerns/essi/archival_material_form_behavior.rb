module ESSI
  module ArchivalMaterialFormBehavior
    extend ActiveSupport::Concern
    # Add behaviors that make this work type unique

    included do
      self.terms += [:viewing_direction, :viewing_hint]
    end
  end
end
