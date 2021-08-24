# Generated via
#  `rails generate hyrax:work BibRecord`
require 'rails_helper'
include Warden::Test::Helpers
include ActiveJob::TestHelper

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a BibRecord', type: :system, js: true do
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
      click_link "Works"
      click_link "Add new work"
      expect(page).to have_content "Select type of work"

      # If you generate more than one work uncomment these lines
      choose "payload_concern", option: "BibRecord"
      VCR.use_cassette('iucat_libraries_up') do
        click_button "Create work"
      end

      expect(page).to have_content "Add New Bib Record"
      click_link "Files" # switch tab
      expect(page).to have_content "Add files"
      expect(page).to have_content "Add folder"
      within('span#addfiles') do
        attach_file(RSpec.configuration.fixture_path + "/world.png", make_visible: true)
        attach_file(RSpec.configuration.fixture_path + "/rgb.png", make_visible: true)
      end
      click_link "Descriptions" # switch tab
      fill_in('Title', with: 'My Test Work')
      fill_in('Source Metadata Identifier', with: ' ') # Workaround until the form is fixed for blank field
      click_link 'Additional fields'
      fill_in('Publication Place', with: 'Wells')

      #select('In Copyright', from: 'Rights statement')

      # With selenium and the chrome driver, focus remains on the
      # select box. Click outside the box so the next line can't find
      # its element
      find('body').click
      choose('bib_record_visibility_open')
      expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as Public) may be viewed as publishing which could impact your ability to')
      page.driver.browser.manage.window.resize_to(1400,1400)
      check('agreement')

      perform_enqueued_jobs do
        click_on('Save')
      end

      # On works dashboard (would probably need a page refresh in actual use)
      expect(page).to have_content('My Test Work', count: 1)
      expect(page).to have_content('1 works you own in the repository')
      expect(page).to have_content "Your files are being processed by Digital Collections in the background."
      click_on('My Test Work')

      # On work show page
      expect(find('.work-type')).to have_content('My Test Work')
      expect(page).to_not have_content "Your files are being processed by Digital Collections in the background."
      expect(find('li.attribute-title')).to have_content('My Test Work')
      click_on('Show Child Items')
      expect(find('table.related-files')).to have_content('rgb.png')

      click_on('Go')
      within '#facets' do
        click_on('Pages')
        expect(page).to have_content('0-99')
        click_on('Publication Place')
        expect(page).to have_content('Wells')
        click_on('State')
        expect(page).to have_content('deposited')
      end
    end
  end
end
