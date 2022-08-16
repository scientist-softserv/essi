RSpec.describe Hyrax::SelectCollectionTypeListPresenter do
  let(:user) { create(:user) }
  let(:ability) { ::Ability.new(user) }
  let(:instance) { described_class.new(ability) }
  let(:authorized_collection) { create(:collection_lw, title: ['Authorized Collection'], user: user) }
  let(:authorized_collection2) { create(:collection_lw, title: ['Authorized Collection 2'], user: user) }
  let(:forbidden_collection) { create(:collection_lw, title: ['Forbidden Collection']) }

  describe "#many?" do
    context "without 0/1 authorized collections" do
      expect(instance.many?).to eq false
    end
    context "without multiple authorized collections", :clean do
      authorized_collection
      authorized_collection2
      expect(instance.many?).to be true
    end
  end

  describe "#any?" do
    context "without any authorized collections" do
      forbidden_collection
      expect(instance.any?).to eq true
    end
    context "with authorized collections", :clean do
      authorized_collection
      expect(instance.many?).to be true
    end
  end

  describe '#options_for_select', :clean do
    let(:subject) { subject.options_for_select.map(&:reverse).to_h }

    it 'returns a sorted array of authorized collection titles, ids (as Strings)' do
      authorized_collection
      forbidden_collection
      expect(subject[authorized_collection.id]).to eq authorized_collection.to_s
      expect(subject[forbidden_collection.id]).to be_nil
    end
  end
end
