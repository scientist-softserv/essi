# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
require 'rails_helper'

RSpec.describe Hyrax::ArchivalMaterialsController do
  include_examples('paged_structure persister',
                   :archival_material,
                   Hyrax::ArchivalMaterialPresenter,
                   described_class)
  include_examples('update metadata remotely', :archival_material)
end
