require 'rails_helper'

describe PurlController do
  let(:user) { FactoryBot.build(:user) }
  purl_redirect_url = ESSI.config.dig(:essi, :purl_redirect_url)
  let(:paged_resource) {
    FactoryBot.create(:paged_resource,
                       user: user,
                       identifier: ['http://purl.dlib.indiana.edu/iudl/variations/score/BHR9405'],
                       source_metadata_identifier: 'BHR9405')
  }
  let(:paged_resource_path) { Rails.application.routes.url_helpers.hyrax_paged_resource_path(paged_resource) }
  let(:file_set) {
    FactoryBot.create(:file_set,
                       user: user,
                       source_metadata_identifier: 'BHR9405-001-0005')
  }
  let(:file_set_path) { Rails.application.routes.url_helpers.hyrax_file_set_path(file_set) }
  let(:original_file_id) { 'xk81jk36q/files/adac151d-9c08-4892-9bc1-a20b64443bb9' }
  let(:jp2_path) { Hyrax.config.iiif_image_url_builder.call(original_file_id, nil, '!600,600') }

  describe 'default', :clean do
    let(:user) { FactoryBot.create(:admin) }
    before do
      sign_in user
      paged_resource
    end
    context 'with a matching id' do
      shared_examples 'responses for matches' do
        before do
          get :default, params: { id: id, format: format }
        end
        context 'when in html' do
          let(:format) { 'html' }

          it 'redirects to the paged_resource page' do
            expect(response).to redirect_to target_path
          end
        end
        context 'when in json' do
          let(:format) { 'json' }

          it 'renders a json response' do
            expect(JSON.parse(response.body)['url']).to match Regexp.escape(target_path)
          end
        end
        context 'when in iiif' do
          let(:format) { 'iiif' }

          it 'redirects to the IIIF manifest' do
            expect(response).to redirect_to manifest_path
          end
        end
      end
      context 'when for a PagedResource' do
        let(:target_path) { paged_resource_path }
        let(:manifest_path) { paged_resource_path + '/manifest' }

        context 'matching by source_metadata_identifier' do
          let(:id) { paged_resource.source_metadata_identifier }
          include_examples 'responses for matches'
        end

        context 'matching a full PURL by identifier' do
          let(:id) { 'iudl/variations/score/BHR9405' }
          include_examples 'responses for matches'
        end
      end
      context 'when for a specific page' do
        let(:id) { paged_resource.source_metadata_identifier + '-9-0042' }
        let(:target_path) { paged_resource_path + '?m=8&cv=41' }
        let(:manifest_path) { paged_resource_path + '/manifest' }

        include_examples 'responses for matches'
      end
    end
    shared_examples 'responses for no matches' do
      let(:target_path) { purl_redirect_url % id }
      before do
        get :default, params: { id: id, format: format }
      end
      context 'when in html' do
        let(:format) { 'html' }

        it "redirects to #{purl_redirect_url}" do
          expect(response).to redirect_to target_path
        end
      end
      context 'when in json' do
        let(:format) { 'json' }

        it 'renders a json response' do
          expect(JSON.parse(response.body)['url']).to match target_path
        end
      end
      context 'when in iiif' do
        let(:format) { 'iiif' }

        it 'returns a 404 response' do
          expect(response.status).to eq 404
        end
      end
    end
    context 'with an invalid id' do
      let(:id) { 'BHR940' }

      before do
        paged_resource
      end
      include_examples 'responses for no matches'
    end
    context 'with an unmatched id' do
      let(:id) { paged_resource.source_metadata_identifier }

      before do
        id
        paged_resource.destroy!
      end
      include_examples 'responses for no matches'
    end
  end

  describe 'formats', :clean do
    before do
      sign_in user
      allow_any_instance_of(Hyrax::FileSetIndexer).to receive(:original_file_id).and_return(original_file_id)
      file_set
      get :formats, params: { id: id, format: format }
    end
    context 'with matching id' do
      let(:id) { file_set.source_metadata_identifier }
      context 'when in html' do
        let(:format) { 'html' }
        it 'redirects to the correct location' do
          expect(response).to redirect_to file_set_path
        end
      end
      context 'when in json' do
        let(:format) { 'json' }

        it 'renders a json response' do
          expect(JSON.parse(response.body)['url']).to match Regexp.escape(file_set_path)
        end
      end
      context 'when in jp2' do
        let(:format) { 'jp2' }
        it 'redirects to the correct location' do
          expect(response).to redirect_to jp2_path
        end
      end
    end
    context 'with a non-matching id' do
      let(:id) { 'id_with_no_result' }
      let(:rescue_url) { purl_redirect_url % id }
      context 'when in html' do
        let(:format) { 'html' }
        it 'redirects to the rescue url' do
          expect(response).to redirect_to rescue_url
        end
      end
      context 'when in json' do
        let(:format) { 'json' }

        it 'renders a json response for the rescue url' do
          expect(JSON.parse(response.body)['url']).to match Regexp.escape(rescue_url)
        end
      end
      context 'when in jp2' do
        let(:format) { 'jp2' }
        it 'returns a 404 response' do
          expect(response.status).to eq 404
        end
      end
    end
  end
end
