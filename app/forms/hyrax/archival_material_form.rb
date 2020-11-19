# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  # Generated form for ArchivalMaterial
  class ArchivalMaterialForm < Hyrax::PagedResourceForm
    self.model_class = ::ArchivalMaterial

    def work_requires_files?
      false
    end
  end
end
