RSpec.shared_examples 'update metadata remotely' do |resource_symbol|

  describe 'when logged in', :clean do
    let(:main_app) { Rails.application.routes.url_helpers }
    let(:user) { FactoryBot.create(:user) }
    let(:resource) { FactoryBot.create(resource_symbol,
                                       user: user,
                                       title: ['Dummy Title'],
                                       source_metadata_identifier: nil) }
    let(:reloaded) { resource.reload }

    before { sign_in user }

    describe '#update' do
      static_attributes = \
        {
          title: ['Updated Title'],
          source_metadata_identifier: 'BHR9405'
        }
      invalid_identifier_attributes = \
        {
          title: ['Updated Title'],
          source_metadata_identifier: 'BHR9405%INVALID$CHARACTERS'
        }
      no_results_identifier_attributes = \
        {
            title: ['Updated Title'],
            source_metadata_identifier: 'VAC1741-00231'
        }

      shared_examples 'redirects to the resource' do |update_attributes, refresh_flag|
        it 'redirects to the resource', vcr: { cassette_name: 'bibdata' }  do
          patch :update,
                params: { id: resource.id,
                          resource_symbol => update_attributes,
                          refresh_remote_metadata: refresh_flag }
          show_page = main_app.send("hyrax_#{resource_symbol}_path", resource, locale: 'en')
          expect(response).to redirect_to show_page
        end
      end

      context 'without remote refresh flag' do
        it 'updates the record but does not refresh the external metadata' do
          perform_enqueued_jobs do
            patch :update,
                 params: { id: resource.id,
                           resource_symbol => static_attributes }
          end
          expect(reloaded.title).to eq ['Updated Title']
        end
        include_examples 'redirects to the resource', static_attributes, false
      end
  
      context 'with remote refresh flag', vcr: { cassette_name: 'bibdata', record: :new_episodes } do
        context 'with an invalid identifier' do
          it 'updates the record' do
            perform_enqueued_jobs do
              patch :update,
                   params: { id: resource.id,
                             resource_symbol => invalid_identifier_attributes,
                             refresh_remote_metadata: true }
            end
            expect(reloaded.title).to eq ['Updated Title']
          end
          it 'flashes an alert about not refreshing the external metadata' do
            perform_enqueued_jobs do
              patch :update,
                 params: { id: resource.id,
                           resource_symbol => invalid_identifier_attributes,
                           refresh_remote_metadata: true }
            end
            expect(flash[:alert]).to match I18n.t('services.remote_metadata.invalid_identifier')
            expect(flash[:alert]).to match I18n.t('services.remote_metadata.validation')
          end
          include_examples 'redirects to the resource', invalid_identifier_attributes, true
        end
        context 'with a valid, non-matching source metadata ID' do
          it 'updates the record' do
            perform_enqueued_jobs do
              patch :update,
                  params: { id: resource.id,
                            resource_symbol => no_results_identifier_attributes,
                            refresh_remote_metadata: true }
            end
            expect(reloaded.title).to eq ['Updated Title']
          end
          it 'flashes an alert about no results found' do
            perform_enqueued_jobs do
              patch :update,
                  params: { id: resource.id,
                            resource_symbol => no_results_identifier_attributes,
                            refresh_remote_metadata: true }
            end
            expect(flash[:alert]).to match I18n.t('services.remote_metadata.no_results')
          end
          include_examples 'redirects to the resource', no_results_identifier_attributes, true
        end
        context 'with a valid, matching source metadata ID' do
          it 'updates the record and refreshes the external metadata' do
            perform_enqueued_jobs do
              patch :update,
                 params: { id: resource.id,
                           resource_symbol => static_attributes,
                           refresh_remote_metadata: true }
            end
            expect(reloaded.title).to eq ['Fontane di Roma ; poema sinfonico per orchestra']
            expect(reloaded.source_metadata_identifier).to eq 'BHR9405'
          end
          include_examples 'redirects to the resource', invalid_identifier_attributes, true
        end
      end
    end
  end
end
