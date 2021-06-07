require 'rails_helper'

RSpec.describe Hyrax::SelectTypeListPresenter do
  let(:user) { FactoryBot.build(:admin) }
  subject { described_class.new(user) }

  describe '#options_for_select' do
    it 'returns a sorted array of work type names, classes (as Strings)' do
      expect(subject.options_for_select.to_h.values).to eq Hyrax.config.registered_curation_concern_types.sort
    end
  end
end
