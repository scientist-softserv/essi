require 'rails_helper'

RSpec.describe CollectionBrandingInfo, type: :model do
  let(:banner) { FactoryBot.build(:collection_branding_banner) }
  let(:file_set) { double(id: 'file_set_id', uri: 'file_set_uri') }
  let(:version) { double(uri: 'version_uri') }
  let(:versions) { double(any?: true, all: self, last: version) }


  describe '#initialize' do
    context 'with local_path value provided' do
      it 'uses the provided value' do
        with_value = FactoryBot.build(:collection_branding_banner, local_path: 'provided_path')
        expect(with_value.local_path).to eq 'provided_path'
      end
    end
    context 'without a local_path value provided' do
      it 'infers a value' do
        without_value = FactoryBot.build(:collection_branding_banner, local_path: nil)
        expect(without_value.local_path).not_to be_empty
      end
    end
  end

  describe '#image_path' do
    it 'is private' do
      expect { banner.image_path }.to raise_error NoMethodError
    end
  end

  describe '#image_path=' do
    it 'is private' do
      expect { banner.image_path = 'val' }.to raise_error NoMethodError
    end
  end

  describe '#save' do
    context  'without an uploaded_file_id or user_key' do
      it 'does not call #attach_file_set' do
        expect(banner).not_to receive(:attach_file_set)
        banner.save
      end
    end
    context  'with an uploaded_file_id and user_key' do
      let(:actor) { double(file_set: file_set, create_metadata: nil, create_content: nil) }
      let(:uploaded_file) { double(update: nil) }
      before do
        allow(FileSet).to receive(:create).and_return(file_set)
        allow(Hyrax::Actors::FileSetActor).to receive(:new).and_return(actor)
        allow(banner).to receive(:uploaded_files).and_return(uploaded_file)
        allow(User).to receive(:find_by_user_key).and_return('user')
      end
      it 'updates the uploaded_file' do
        expect(uploaded_file).to receive(:update)
        banner.save(uploaded_file_id: 1, user_key: 'user')
      end
      it 'updates the file_set_id' do
        expect(banner.file_set_id).not_to eq file_set.id
        banner.save(uploaded_file_id: 1, user_key: 'user')
        expect(banner.file_set_id).to eq file_set.id
      end
      it 'creates FileSet metadata' do
        expect(actor).to receive(:create_metadata)
        banner.save(uploaded_file_id: 1, user_key: 'user')
      end
      it 'creates FileSet content' do
        expect(actor).to receive(:create_content)
        banner.save(uploaded_file_id: 1, user_key: 'user')
      end
    end
  end
  describe '#file_set_image_path' do
    context 'with an image_path available' do
      it 'returns the image path' do
        expect(banner.file_set_image_path).to eq banner.send(:image_path)
      end
    end
    context 'without an image_path value' do
      before do
        banner.send(:image_path=, nil)
      end
      context 'and unable to generate one' do
        before do
          allow(banner).to receive(:file_set_versions).and_return([])
        end
        it 'returns nil' do
          expect(banner.file_set_image_path).to be_nil
        end
      end
      context 'but able to generate one' do
        before do
          allow(banner).to receive(:file_set_versions).and_return(versions)
          allow(versions).to receive(:all).and_return(versions)
        end
        it 'sets the image_path value' do
          expect(banner).to receive(:image_path=)
          banner.file_set_image_path
        end
        it 'returns the image_path value' do
          expect(banner.file_set_image_path).to match version.uri
        end
      end
    end
  end
  describe '#display_hash' do
    it 'returns a values hash' do
      expect(banner.display_hash).to be_a Hash
    end
  end
end
