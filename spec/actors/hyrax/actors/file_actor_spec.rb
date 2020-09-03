require 'spec_helper'
require 'rails_helper'

describe Hyrax::Actors::FileActor do
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:png_filename) { Rails.root.join("spec", "fixtures", "world.png").to_s }
  let(:tiff_filename) { Rails.root.join("spec", "fixtures", "ocr_test.tiff").to_s }
  let(:user)     { FactoryBot.create(:user) }
  let(:file_actor) { described_class.new(file_set, :original_file, user) }
  let(:png_file) { File.new(png_filename) }
  let(:tiff_file) { File.new(tiff_filename) }
  let(:file) { png_file }
  let(:io) { JobIoWrapper.create_with_varied_file_handling!(user: user, file: file, relation: :original_file, file_set: file_set) }

  describe '#ingest_file' do
    before do
      allow(ESSI.config).to receive(:dig).with(any_args).and_call_original
      allow(ESSI.config).to receive(:dig).with(:essi, :create_ocr_files) \
        .and_return(true)
      allow(ESSI.config).to receive(:dig).with(:essi, :index_ocr_files) \
        .and_return(true)
      allow(ESSI.config).to receive(:dig) \
        .with(:essi, :master_file_service_url) \
        .and_return('http://service')
    end
    context 'when :store_original_files is false', :clean do
      before do
        allow(ESSI.config).to receive(:dig)
          .with(:essi, :store_original_files) \
          .and_return(false)
      end
      describe 'stores masters as original_file' do
        it 'sets the mime_type to an external body redirect' do
          file_actor.ingest_file(io)
          expect(file_set.reload.original_file.mime_type).to include \
            ESSI.config.dig :essi, :master_file_service_url
        end
        it 'does not run characterization' do
          expect(CharacterizeJob).not_to receive(:perform_later)
          file_actor.ingest_file(io)
        end
      end
    end
  
    context 'when :store_original_files is true', :clean do
      before do
        allow(ESSI.config).to receive(:dig) \
          .with(:essi, :store_original_files) \
          .and_return(true)
      end
      it 'saves an image file to the member file_set' do
        file_actor.ingest_file(io)
        expect(file_set.reload.original_file.mime_type).to include "image/png"
      end
      context 'when the file_set is for collection branding' do
        before do
          allow(file_set).to receive(:collection_branding?).and_return(true)
        end
        it 'does not run characterization' do
          expect(CharacterizeJob).not_to receive(:perform_later)
          file_actor.ingest_file(io)
        end
      end
      context 'when the file_set is not for collection branding' do
        before do
          allow(file_set).to receive(:collection_branding?).and_return(false)
        end
        it 'runs characterization' do
          expect(CharacterizeJob).to receive(:perform_later) \
            .with(file_set, String, String, String)
          file_actor.ingest_file(io)
        end
      end
      context 'when jp2 transformation is configured' do
        let(:file) { tiff_file }
        before do
          allow(ESSI.config).to receive(:dig).with(:essi, :store_files_as_jp2) \
            .and_return(true)
        end
        it 'turns tiffs into jp2' do
          expect(file_actor).to receive(:transform_to_jp2)
          file_actor.ingest_file(io)
        end
        it 'changes FileSet extension' do
          expect(file_set.label).not_to match /jp2$/
          file_actor.ingest_file(io)
          expect(file_set.label).to match /jp2$/
        end
        it 'changes FileSet mimetype' do
          expect(file_set.mime_type).not_to match /jp2/
          file_actor.ingest_file(io)
          expect(file_set.mime_type).to match /jp2/
        end
        it 'runs jp2-based characterization, tiff-based derivation' do
          expect(CharacterizeJob).to receive(:perform_later) \
            .with(file_set, String, /jp2/, tiff_filename)
          file_actor.ingest_file(io)
        end
      end
      context 'when jp2 transformation is not configured' do
        let(:file) { tiff_file }
        before do
          allow(ESSI.config).to receive(:dig).with(:essi, :store_files_as_jp2) \
            .and_return(false)
        end
        it 'does not turn tiffs into jp2' do
          expect(file_actor).not_to receive(:transform_to_jp2)
          file_actor.ingest_file(io)
        end
        it 'retains FileSet extension' do
          expect(file_set.label).not_to match /jp2$/
          file_actor.ingest_file(io)
          expect(file_set.label).not_to match /jp2$/
        end
        it 'retains FileSet mimetype' do
          expect(file_set.mime_type).not_to match /jp2/
          file_actor.ingest_file(io)
          expect(file_set.mime_type).not_to match /jp2/
        end
        it 'runs tiff-based characterization and derivation' do
          expect(CharacterizeJob).to receive(:perform_later) \
            .with(file_set, String, tiff_filename, tiff_filename)
          file_actor.ingest_file(io)
        end
      end
      describe 'stores masters as preservation_master_file' do
        it 'sets the mime_type to an external body redirect' do
          file_actor.ingest_file(io)
          expect(file_set.reload.preservation_master_file.mime_type).to include \
            ESSI.config.dig :essi, :master_file_service_url
        end
      end
    end
  end
end
