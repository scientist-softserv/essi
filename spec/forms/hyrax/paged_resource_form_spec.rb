# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'

RSpec.describe Hyrax::PagedResourceForm do
  let(:work) { FactoryBot.build(:paged_resource) }
  let(:ability) { Ability.new(FactoryBot.create(:user)) }
  let(:controller) { double(params: {}) }
  let(:form) { described_class.new(work, ability, controller) }

  describe '#work_requires_files?' do
    it 'returns true' do
      expect(form.work_requires_files?).to eq true
    end
  end
end
