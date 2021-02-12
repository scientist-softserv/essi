require 'rails_helper'

RSpec.describe Hyrax::ImagesController do
  include_examples("update metadata", :image)
end
