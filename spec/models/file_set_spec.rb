require 'rails_helper'

RSpec.describe FileSet do
  let(:file_set) { FactoryBot.build(:file_set) }
  let(:collection_branding_info) { FactoryBot.build(:collection_branding_banner, file_set_id: nil) }

  describe 'collection_branding_info' do
    context 'with an associated CollectionBrandingInfo' do
      before do
        file_set.save!
        collection_branding_info.update_attributes!(file_set_id: file_set.id)
      end
      it 'returns the object' do
        expect(file_set.collection_branding_info).to eq collection_branding_info
      end
    end
    context 'without an associated CollectionBrandingInfo' do
      it 'returns nil' do
        expect(file_set.collection_branding_info).to be_nil
      end
    end
  end

  describe '#collection_branding?' do
    context 'without an associated branding object' do
      it 'returns false' do
        expect(file_set.collection_branding?).to be false
      end
    end
    context 'with an associated branding object' do
      before do
        allow(file_set).to receive(:collection_branding_info).and_return(collection_branding_info)
      end
      it 'returns true' do
        expect(file_set.collection_branding?).to be true
      end
    end
  end
end
