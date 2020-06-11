require 'rails_helper'

RSpec.describe Processors::OCR do
  subject { described_class.new(source_path, directives) }

  let(:source_path) { '' }

  describe "#encode" do
    it "executes the external utility" do
      expect(described_class).to receive(:execute).at_least(1).times { 0 }
      described_class.encode('path', {}, 'output_file')
    end
  end

  describe "#options_for" do
    context "without a language directive" do
      let(:directives) { {} }
      it "returns a hash with a default tesseract language argument" do
        expect(subject.options_for('alto')&.dig(:options).to_s).to match /-l eng/
      end
    end
    context "with a language directive" do
      let(:directives) { { language: 'ita' } }
      it "returns a hash with the specified tesseract language argument" do
        expect(subject.options_for('alto')&.dig(:options).to_s).to match /-l ita/
      end
    end
  end
end
