require 'rails_helper'

RSpec.describe ESSI::ImportLocalFileSuccessService do
  let!(:depositor) { create(:user) }
  let(:file_set) { create(:file_set, user: depositor) }
  let(:path) { '/path/to/file' }
  let(:service) { described_class.new(file_set, depositor, path) }

  before do
    allow(file_set.errors).to receive(:full_messages).and_return([])
  end

  describe "#call" do
    it "logs info" do
      expect(service.service_logger).to receive(:info)
      service.call
    end
  end
end
