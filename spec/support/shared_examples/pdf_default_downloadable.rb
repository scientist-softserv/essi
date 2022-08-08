RSpec.shared_examples "pdf default downloadable" do
  describe "#pdf_state" do
    it "is downloadable by default" do
      expect(described_class.new.pdf_state).to eq 'downloadable'
    end
  end
end
