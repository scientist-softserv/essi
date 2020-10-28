require 'rails_helper'

RSpec.describe CampusService do
  let(:service) { described_class }
  let(:id) { 'IUB' }

  describe "#find" do
    it "delegates to the authority" do
      expect(service.authority).to receive(:find).with(id)
      service.find(id)
    end
  end

  describe "#select_options" do
   it "returns an Array of label/id pairs" do
      expect(service.select_options).to be_a Array
      expect(service.select_options.first.size).to eq 2
    end
    it "returns an sorted Array" do
      expect(service.select_options).to eq service.select_options.sort
    end
  end

  describe "#select_all_options" do
    it "returns an Array of label/id pairs" do
      expect(service.select_all_options).to be_a Array
      expect(service.select_all_options.first.size).to eq 2
    end
    it "returns an unsorted Array" do
      expect(service.select_all_options).not_to eq service.select_all_options.sort
    end
  end

  describe "#campuses" do
    it "returns all campuses" do
      expect(service.campuses.count).to eq service.select_all_options.count
    end
    it "returns Campus objects for display" do
      expect(service.campuses.first).to be_a service::Campus
    end
  end
end
