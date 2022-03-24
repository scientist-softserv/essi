require 'rails_helper'

RSpec.describe ESSI::ImportLocalFileFailureService do
  let!(:depositor) { create(:user) }
  let(:file_set) { create(:file_set, user: depositor) }
  let(:path) { '/path/to/file' }
  let(:service) { described_class.new(file_set, depositor, path) }

  before do
    allow(file_set.errors).to receive(:full_messages).and_return(['First error', 'Second error'])
  end

  describe "#call" do
    it "logs error" do
      expect(service.service_logger).to receive(:error)
      service.call
    end
  end
end
