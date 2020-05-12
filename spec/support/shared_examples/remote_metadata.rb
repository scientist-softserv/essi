RSpec.shared_examples 'update metadata remotely' do |resource_symbol|

  describe 'when logged in', :clean do

    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }
    let(:user) { FactoryBot.create(:user) }

    before { sign_in user }

    describe '#update' do

      let(:resource) { FactoryBot.create(resource_symbol, user: user, title: ['Dummy Title']) }
      let(:reloaded) { resource.reload }
      let(:static_attributes) {
        {
          description: ['a description'],
          source_metadata_identifier: 'BHR9405'
        }
      }
      let(:invalid_identifier_attributes) {
        {
          description: ['a description'],
          source_metadata_identifier: 'BHR9405%INVALID$CHARACTERS'
        }
      }

      context 'without remote refresh flag' do
        it 'updates the record but does not refresh the external metadata' do
          patch :update,
               params: { id: resource.id,
                         resource_symbol => static_attributes }
          expect(reloaded.title).to eq ['Dummy Title']
          expect(reloaded.description).to eq ['a description']
        end
      end
  
      context 'with remote refresh flag', vcr: { cassette_name: 'bibdata', record: :new_episodes } do
        context 'with an invalid identifier' do
          it 'updates the record' do
            patch :update,
                 params: { id: resource.id,
                           resource_symbol => invalid_identifier_attributes,
                           refresh_remote_metadata: true }
            expect(reloaded.description).to eq ['a description']
          end
          it 'flashes an alert about not refreshing the external metadata' do
            patch :update,
                 params: { id: resource.id,
                           resource_symbol => invalid_identifier_attributes,
                           refresh_remote_metadata: true }
            expect(flash[:alert]).to match I18n.t('services.remote_metadata.invalid_identifier')
            expect(flash[:alert]).to match I18n.t('services.remote_metadata.validation')
          end
        end
        context 'with a valid, matching source metadata ID' do
          it 'updates the record and refreshes the external metadata' do
            patch :update,
                 params: { id: resource.id,
                           resource_symbol => static_attributes,
                           refresh_remote_metadata: true }
            expect(reloaded.title).to eq ['Fontane di Roma ; poema sinfonico per orchestra']
            expect(reloaded.description).to eq ['a description']
          end
        end
      end
    end
  end
end
