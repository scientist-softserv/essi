require 'rails_helper'

RSpec.describe Hyrax::ScientificsController do
  include_examples("update metadata", :scientific)
end
