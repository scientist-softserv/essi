require 'rails_helper'

RSpec.describe AllinsonFlex::ProfilesController, type: :controller do
  routes { AllinsonFlex::Engine.routes }

  context "when logged in as an admin user" do
    let(:user) { FactoryBot.create(:admin) }

    before do
      sign_in user
      allow_any_instance_of(user.class).to receive(:groups).and_return(['admin'])
    end

    describe 'POST #import', :clean do
      context 'with no file' do
        it 'redirects and alerts the file requirement' do
          post :import, params: { file: '' }
          expect(response).to be_redirect
          expect(flash[:alert]).to eq('Please select a file to upload')
        end
      end
      context 'with valid profile data' do
        let(:file) { fixture_file_upload('allinson_flex/yaml_example.yaml') }
        it 'redirects and notices the successful upload' do
          post :import, params: { file: file }
          expect(response).to be_redirect
          expect(flash[:notice]).to match /AllinsonFlexProfile was successfully created/
        end
      end
    end
  end
end
