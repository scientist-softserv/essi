# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'
include Warden::Test::Helpers
include ActiveJob::TestHelper
include CapybaraWatcher

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create and run a CSV Importer', type: :system, js: true do
  context 'a logged in user', clean: true do
    let(:user) do
      FactoryBot.create :user
    end
    let!(:default_admin_set) { AdminSet.find(AdminSet.find_or_create_default_admin_set_id) }
    let(:test_admin_set) { FactoryBot.create :admin_set, title: ['Test Admin Set'] }
    let(:default_permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: default_admin_set.id) }
    let(:test_permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: test_admin_set.id) }
    let(:default_workflow) { Sipity::Workflow.create!(active: true, name: 'default-workflow', permission_template: default_permission_template) }
    let(:test_workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: test_permission_template) }

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: default_workflow)
      Sipity::WorkflowAction.create!(name: 'submit', workflow: test_workflow)

      # Grant the user access to deposit into the admin sets
      [default_permission_template, test_permission_template].each do |permission_template|
        Hyrax::PermissionTemplateAccess.create!(
          permission_template_id: permission_template.id,
          agent_type: 'user',
          agent_id: user.user_key,
          access: 'deposit'
        )
      end
      # Ensure empty requirement for ldap group authorization
      allow(ESSI.config[:authorized_ldap_groups]).to receive(:blank?).and_return(true)
      login_as user

      # monkeypatch for default CollectionType GID issue in test environment
      allow(Hyrax::CollectionType).to receive(:find_by_gid!).and_return(Hyrax::CollectionType.find_or_create_default_collection_type)
    end

    scenario do
      visit '/dashboard'
      click_link "Importers"
      click_link "New"

      expect(page).to have_content "New Importer"
      expect(page).to_not have_content "METS XML and files to Import"
      fill_in 'Name', with: 'CSV Test Importer'
      select 'Test Admin Set', from: 'Administrative Set'
      select 'Once (on save)', from: 'Frequency'
      fill_in 'Limit', with: ''
      select 'CSV - Comma Separated Values', from: 'Parser'

      expect(page).to have_content 'Add CSV File to Import'
      within '.csv_fields' do
        select 'Public', from: 'Visibility'
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

      # wait until modal has closed and Add Cloud Files button has updatedto Cloud Files Added
      wait_until_content_has "Cloud Files Added" do |text|
        page.should have_content text
      end
      expect(page).to have_field 'selected_files[0][url]', type: 'hidden', with: /rgb\.png/
      expect(page).to have_field 'selected_files[1][url]', type: 'hidden', with: /world\.png/

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
      expect(page).to have_content 'Test Admin Set'
      click_on(I18n.t('hyrax.works.form.show_child_items'))
      expect(find('table.related-files')).to have_content('rgb.png')
      expect(find('table.related-files')).to have_content('world.png')
      expect(find('table.related-files')).to have_content('Public')

      click_link 'Testing Collection', match: :first
      expect(page).to have_content 'A Test Image'
    end
  end
end

