require 'spec_helper'
require 'rails_helper'
include ActiveJob::TestHelper

describe IngestYAMLJob do
  before(:context) do
    ActiveFedora::Cleaner.clean!  # Clean just once for the context, not each example.
    AdminSet.create id: AdminSet::DEFAULT_ID, title: Array.wrap(AdminSet::DEFAULT_TITLE)
    RSpec::Mocks.with_temporary_scope do
      @paged_resource_yaml = Rails.root.join('spec', 'fixtures', 'paged_resource.yml').to_s
      @user = FactoryBot.create(:user)
      expect(PagedResource.count.zero?).to be true
      perform_enqueued_jobs do
        described_class.perform_now(@paged_resource_yaml, @user)
      end
    end
  end

  describe 'for a single PagedResource' do
    subject { PagedResource.where(title: 'Untitled Paged Resource').first }

    it 'creates only one work' do
      expect(PagedResource.count).to eq 1
    end

    it 'creates a PagedResource with logical structure' do
      expect(subject.logical_order.order).to be_present
    end
    it 'attaches a FileSet to the PagedResource' do
      expect(subject.file_sets.any?).to be true
    end
    it 'attaches a file to the created FileSet' do
      expect(IngestLocalFileJob).to have_been_performed
      expect(subject.file_sets.first.original_file).to be_present
    end
  end
end
