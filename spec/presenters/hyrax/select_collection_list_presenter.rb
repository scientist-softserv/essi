RSpec.describe Hyrax::SelectCollectionTypeListPresenter, :clean_repo do
  let(:user) { create(:user) }
  let(:ability) { ::Ability.new(user) }
  let(:instance) { described_class.new(ability) }
  let(:authorized_collection) { create(:collection_lw, title: ['Authorized Collection'], user: user) }
  let(:forbidden_collection) { create(:collection_lw, title: ['Forbidden Collection']) }

  describe '#options_for_select' do
    let(:subject) { subject.options_for_select.map(&:reverse).to_h }

    it 'returns a sorted array of authorized collection titles, ids (as Strings)' do
      expect(subject[authorized_collection.id]).to eq authorized_collection.to_s
      expect(subject[forbidden_collection.id]).to be_nil
    end
  end
end
