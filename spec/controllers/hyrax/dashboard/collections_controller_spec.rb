require 'rails_helper'

RSpec.describe Hyrax::Dashboard::CollectionsController, :clean_repo do
  routes { Hyrax::Engine.routes }
  let(:user) { FactoryBot.create(:user) }
  let(:collection_type) { double(:brandable, true) }
  let(:collection_type_gid) { FactoryBot.create(:user_collection_type).gid }
  let(:collection) { Collection.create(title: ['Test collection'],
                                       collection_type_gid: collection_type_gid,
                                       visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  let(:banner) { FactoryBot.build(:collection_branding_banner) }

  describe "#show" do
    before do
      sign_in user
      allow(collection).to receive(:brandable?).and_return(true)
    end

    context 'with a collection branding banner present' do
      before do
        allow_any_instance_of(Collection).to receive(:banner_branding).and_return([banner])
        allow(banner).to receive(:file_set_image_path).and_return('file_set_image_path')
      end

      it 'assigns a banner file' do
        get :show, params: { id: collection.id }
        expect(assigns(:banner_file)).not_to be_nil
      end
    end

    context 'without a collection branding banner present' do
      it 'assigns collection branding' do
        get :show, params: { id: collection.id }
        expect(assigns(:banner_file)).to be_nil
      end
    end
  end
end
