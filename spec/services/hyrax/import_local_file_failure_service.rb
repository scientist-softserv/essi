require 'rails_helper'

RSpec.describe Hyrax::ImportLocalFileFailureService do
  let!(:depositor) { create(:user) }
  let(:inbox) { depositor.mailbox.inbox }
  let(:file_set) do
    create(:file_set, user: depositor)
  end
  let(:path) { '/path/to/file' }

  before do
    allow(file_set.errors).to receive(:full_messages).and_return(['First error', 'Second error'])
  end

  describe "#call" do
    before do
      described_class.new(file_set, depositor, path).call
    end

    it "sends failing mail" do
      expect(inbox.count).to eq(1)
      expect(inbox.first.last_message.subject).to eq('Failing Import Local File')
    end
  end
end
