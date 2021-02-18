# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'
include Warden::Test::Helpers
include ActiveJob::TestHelper

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create and run a CSV Importer', type: :system, js: true do
  context 'a logged in user', clean: true do
    let(:user) do
      FactoryBot.create :user
    end
    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)

      # Grant the user access to deposit into the admin set.
      Hyrax::PermissionTemplateAccess.create!(
        permission_template_id: permission_template.id,
        agent_type: 'user',
        agent_id: user.user_key,
        access: 'deposit'
      )
      # Ensure empty requirement for ldap group authorization
      allow(ESSI.config[:authorized_ldap_groups]).to receive(:blank?).and_return(true)
      login_as user
    end

    scenario do
      visit '/dashboard'
      click_link "Importers"
      click_link "New"

      expect(page).to have_content "New Importer"
      expect(page).to_not have_content "METS XML and files to Import"
      fill_in 'Name', with: 'CSV Test Importer'
      select 'Default Admin Set', from: 'Administrative Set'
      select 'Once (on save)', from: 'Frequency'
      fill_in 'Limit', with: ''
      select 'CSV - Comma Separated Values', from: 'Parser'

      expect(page).to have_content 'Add CSV File to Import'
      within '.csv_fields' do
        select 'Private', from: 'Visibility'
        select 'In Copyright', from: 'Rights statement'
        choose 'Upload a File'

        expect(page).to have_selector 'input#importer_parser_fields_file'
        attach_file 'importer[parser_fields][file]', RSpec.configuration.fixture_path + "/test_image.csv"

        click_button 'Add Cloud Files'
      end

      within('#browse-everything') do
        expect(page).to have_content '0 files selected'
        select 'File System', from: 'provider-select'
        expect(page).to have_link 'rgb.png'
        check 'rgb-png'
        expect(page).to have_content '1 file selected'
        check 'world-png'
        expect(page).to have_content '2 files selected'
        click_button 'Submit'
      end

      within '.csv_fields' do
        expect(page).to have_content 'spec/fixtures/rgb.png'
        expect(page).to have_content 'spec/fixtures/world.png'
        expect(page).to have_content 'Cloud Files Added'
      end

      perform_enqueued_jobs do
        click_button 'Create and Import'
      end

      expect(page).to have_content 'Importer was successfully created and import has been queued.'
      expect(page).to have_content 'CSV Test Importer', count: 1
      expect(page).to have_content 'Complete'
      # expect(page).to_not have_content '(with failures)'

      click_link 'CSV Test Importer'
      expect(page).to have_content 'Importer: CSV Test Importer'
      expect(page).to have_content 'Parser klass: Bulkrax::CsvParser'
      expect(page).to have_content 'TEST-1234', count: 1

      click_link 'TEST-1234'
      expect(page).to have_content 'Identifier: TEST-1234'

      click_link 'Image'
      # On work show page
      expect(page).to have_content 'A Test Image'
      expect(page).to have_content '0-99 pages'

      click_on('Show Child Items')
      expect(find('table.related-files')).to have_content('rgb.png')
      expect(find('table.related-files')).to have_content('world.png')

      click_link 'Testing Collection', match: :first
      expect(page).to have_content 'A Test Image'

    end
  end
end
