require 'spec_helper'
require 'rails_helper'

RSpec.describe Hyrax::Collections::CollectionMemberService, clean_repo: true do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:repository) { Blacklight::Solr::Repository.new(blacklight_config) }
  let(:current_ability) { instance_double(Ability, admin?: true) }
  let!(:nestable_collection) { create(:public_collection_lw, collection_type_settings: [:nestable]) }
  let(:solr_hash) { nestable_collection.to_solr }
  let(:solr_doc) { SolrDocument.new(solr_hash) }
  let(:presenter) { Hyrax::CollectionPresenter.new(solr_doc, current_ability) }

  let(:scope) { double('Scope', current_ability: current_ability, repository: repository, blacklight_config: blacklight_config, collection: nestable_collection) }
  let!(:subcollection) { create(:public_collection_lw, member_of_collections: [nestable_collection], collection_type_settings: [:nestable]) }
  let(:builder) { described_class.new(scope: scope, collection: presenter, params: { 'id' => nestable_collection.id.to_s }) }
  let(:cq_builder) { described_class.new(scope: scope, collection: presenter, params: { 'id' => nestable_collection.id.to_s, 'cq' => 'query' }) }

  let!(:work1) { create(:paged_resource, member_of_collections: [nestable_collection]) }
  let!(:work2) { create(:paged_resource, member_of_collections: [subcollection]) }

  describe '#available_member_subcollections' do
    let(:subject) { builder.available_member_subcollections }
    let(:ids) { subject.response[:docs].map { |col| col[:id] } }

    it 'returns direct members that are collections' do
      expect(ids).to include(subcollection.id)
      expect(ids).not_to include(work1.id)
      expect(ids).not_to include(work2.id)
    end
  end

  describe '#available_member_works' do
    describe 'when cq parameter contains query string' do
      let(:subject) { cq_builder.available_member_works }
      let(:ids) { subject.response[:docs].map { |col| col[:id] } }

      it 'returns members in the tree that are works' do
        expect(ids).to include(work1.id)
        expect(ids).to include(work2.id)
      end
    end
    describe 'when cq parameter is not present' do
      let(:subject) { builder.available_member_works }
      let(:ids) { subject.response[:docs].map { |col| col[:id] } }

      it 'returns direct members that are works' do
        expect(ids).to include(work1.id)
        expect(ids).not_to include(work2.id)
      end
    end
  end

  describe '#available_member_work_ids' do
    describe 'when cq parameter contains query string' do
      let(:subject) { cq_builder.available_member_work_ids }
      let(:ids) { subject.response[:docs].map { |col| col[:id] } }

      it 'returns member ids in the tree that are works' do
        expect(ids).to include(work1.id)
        expect(ids).to include(work2.id)
      end
      describe 'when cq parameter is not present' do
        let(:subject) { builder.available_member_work_ids }
        let(:ids) { subject.response[:docs].map { |col| col[:id] } }

        it 'returns direct member ids that are works' do
          expect(ids).to include(work1.id)
          expect(ids).not_to include(work2.id)
        end
      end
    end
  end
end
