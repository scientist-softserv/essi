require 'rails_helper'

RSpec.describe 'IIIF image API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:work) { FactoryBot.create(:paged_resource_with_one_image, user: user) }
  let(:file_set) { work.ordered_members.to_a.first }
  let(:file) { file_set.original_file }
  let(:auth_params) { [ESSI.config[:fedora][:user], ESSI.config[:fedora][:password]] }

  describe 'GET /images/:id' do

    it 'should include http basic auth' do
      login_as user

      expect(Riiif::HttpFileResolver::RemoteFile).to receive(:new).with(
        anything, hash_including(basic_auth_credentials: auth_params )).and_call_original

      get Riiif::Engine.routes.url_helpers.image_path(file.id, size: 'max')
      expect(response).to have_http_status(:ok)

    end
  end
end
