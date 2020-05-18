require 'rails_helper'

RSpec.describe Hyrax::CollectionPresenter do
  subject { described_class.new(double, double) }
  let(:banner) do
    CollectionBrandingInfo.new(
      collection_id: '1',
      filename: 'banner.png',
      role: 'banner',
      image_path: '/fake/path/to/banner'
    )
  end
  let(:logo) do
    CollectionBrandingInfo.new(
      collection_id: '1',
      filename: 'logo.png',
      role: 'logo',
      alt_txt: '',
      target_url: '',
      image_path: '/fake/path/to/banner'
    )
  end

  describe '.campus_logo' do
    before do
      name = 'The Collection'
      @snake = 'the_collection'
      @title = 'The Title'
      @url = 'http://university.edu'
      collection = double('CollectionType', title: name)
      allow(subject).to receive(:collection_type).and_return(collection)
      @campus_logos = ESSI.config[:essi][:campus_logos]
    end
  
    context 'When initialized' do
      it 'is available' do
        expect(subject).to respond_to(:campus_logo)
      end
    end
  
    context 'When campus_logos is not configured' do
      it 'returns false' do
        ESSI.config[:essi][:campus_logos] = nil
        expect(subject.campus_logo).to be false
      end
    end
  
    context 'When collection matches configuration' do
      it 'returns configured values' do
        ESSI.config[:essi][:campus_logos][@snake] = { title: @title, url: @url }
        expect(subject.campus_logo).to include(@title)
        expect(subject.campus_logo).to include(@url)
      end
    end
  
    after do
      ESSI.config[:essi][:campus_logos] = @campus_logos
    end
  end

  describe '#banner_file' do
    before do
      allow(subject).to receive(:id).and_return('1')
    end
    context 'without a banner available' do
      it 'returns nil' do
        expect(subject.banner_file).to be_blank
      end
    end
    context 'with a banner available' do
      before do
        allow(CollectionBrandingInfo).to receive(:where).with(collection_id: '1', role: 'banner').and_return([banner])
      end
      it 'returns the image path' do
        expect(subject.banner_file).to be_present
      end
    end
  end

  describe '#logo_record' do
    before do
      allow(subject).to receive(:id).and_return('1')
    end
    context 'without logos available' do
      it 'returns an empty array' do
        expect(subject.logo_record).to be_empty   
      end
    end
    context 'with logos available' do
      before do
        allow(CollectionBrandingInfo).to receive(:where).with(collection_id: '1', role: 'logo').and_return([banner])
      end
      it 'returns an array of display value hashes' do
        expect(subject.logo_record).not_to be_empty   
      end
    end
  end
end
