require 'rails_helper'

RSpec.describe Collection do
  let(:collection_type) { double(:brandable, true) }
  let(:collection_type_gid) { FactoryBot.create(:user_collection_type).gid }
  let(:collection) { Collection.create(title: ['Persisted collection'],
                                       collection_type_gid: collection_type_gid,
                                       visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  let(:new_collection) { Collection.new(title: ['Unpersisted collection'],
                                          collection_type_gid: collection_type_gid,
                                          visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  let(:fs1) { FactoryBot.create(:file_set) }
  let(:fs2) { FactoryBot.create(:file_set) }
  let(:files) { [[fs1.title, fs1.id], [fs2.title, fs2.id]] }


  describe "#default_thumbnail_id", :clean do
    context "with no thumbnails available" do
      before do
        allow_any_instance_of(Hyrax::Forms::CollectionForm).to \
          receive(:send).with(:all_files_with_access).and_return([])
      end
      it "returns nil" do
        expect(collection.default_thumbnail_id).to be_nil
      end
    end
    context "with a thumbnail available" do
      before do
        allow_any_instance_of(Hyrax::Forms::CollectionForm).to \
          receive(:send).with(:all_files_with_access).and_return(files)
      end
      it "returns first id value" do
        expect(collection.default_thumbnail_id).to eq fs1.id
      end
    end
  end

  describe "#save", :clean do
    context "with a thumbnail already specified" do
      before do
        allow(collection).to receive(:default_thumbnail_id).and_return(fs1.id)
      end
      it "retains the existing thumbnail" do
        collection.thumbnail_id = fs2.id
        collection.save
        collection.reload
        expect(collection.thumbnail_id).to eq fs2.id
      end
    end
    context "without a thumbnail specified" do
      context "without a default thumbnail available" do
        before do
          allow(collection).to receive(:default_thumbnail_id).and_return(nil)
        end
        context "a new (unpersisted) collection" do
          it "keeps an empty thumbnail" do
            new_collection.thumbnail_id = nil
            new_collection.save
            new_collection.reload
            expect(new_collection.thumbnail_id).to be_nil
          end
        end
        context "an existing (persisted) collection" do
          it "keeps an empty thumbnail" do
            collection.thumbnail_id = nil
            collection.save
            collection.reload
            expect(collection.thumbnail_id).to be_nil
          end
        end
      end
      context "with a default thumbnail available" do
        before do
          allow(collection).to receive(:default_thumbnail_id).and_return(fs1.id)
        end
        context "a new (unpersisted) collection" do
          it "keeps an empty thumbnail" do
            new_collection.thumbnail_id = nil
            new_collection.save
            new_collection.reload
            expect(new_collection.thumbnail_id).to be_nil
          end
        end
        context "an existing (persisted) collection" do
          it "sets the default thumbnail" do
            collection.thumbnail_id = nil
            collection.save
            collection.reload
            expect(collection.thumbnail_id).to eq fs1.id
          end
        end
      end
    end
  end
end
