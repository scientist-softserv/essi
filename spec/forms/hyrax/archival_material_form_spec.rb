require 'rails_helper'

RSpec.describe Hyrax::ArchivalMaterialForm, :clean do
  let(:work) { FactoryBot.build(:archival_material) }
  let(:ability) { Ability.new(FactoryBot.create(:user)) }
  let(:controller) { double(params: {}) }
  let(:form) { described_class.new(work, ability, controller) }

  describe '#work_requires_files?' do
    it 'returns false' do
      expect(form.work_requires_files?).to eq false
    end
  end
end
