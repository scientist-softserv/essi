require 'rails_helper'

RSpec.describe MetsStructure do
  class MetsTester
    include MetsStructure
    def initialize(mets_file)
      @source_file = mets_file
      @mets = File.open(@source_file) { |f| Nokogiri::XML(f) }
    end
    def multi_volume?; false; end
  end
  let(:subject) { MetsTester.new('spec/fixtures/xml/mets.xml') }

  describe "#structure" do
    let(:structure) { subject.structure }
    describe "labelling" do
      context "given a LABEL" do
        let(:node) { subject.structure[:nodes][0] }
        it "returns LABEL value" do
          expect(node[:label]).to eq "VAC1741-U-00064 LABEL"
        end
      end
      context "given a FILEID" do
        let(:node) { subject.structure[:nodes][1] }
        it "returns ID value (instead)" do
          expect(node[:label]).to eq "VAC1741-U-00065"
        end
      end
      context "given an ID" do
        let(:node) { subject.structure[:nodes][2] }
        it "returns ID value" do
          expect(node[:label]).to eq "VAC1741-U-00066"
        end
      end
      context "given ORDER and TYPE" do
        let(:node) { subject.structure[:nodes][3] }
        it "returns TYPE ORDER" do
          expect(node[:label]).to eq "archivalitem 4"
        end
      end
      context "given nothing" do
        let(:node) { subject.structure[:nodes][4] }
        it "returns blank" do
          expect(node[:label]).to be_blank
        end
      end
    end
  end
end
