require 'rails_helper'

RSpec.describe Qa::Authorities::Campuses do
  let(:authority) { described_class.new } 

  describe '#search' do
    context 'with a nonmatching id' do
      it 'returns an empty Array' do
        expect(authority.search('XXX')).to be_empty
      end
    end
    context 'with a matching id' do
      it 'returns a populated Array' do
        expect(authority.search('IU')).not_to be_empty
      end
    end
  end

  describe '#find' do
    context 'with a nonmatching id' do
      it 'returns an empty Hash' do
        expect(authority.find('IU')).to be_empty
      end
    end
    context 'with a matching id' do
      it 'returns a populated Hash' do
        expect(authority.search('IUB')).not_to be_empty
      end
    end
  end

  describe '#all' do
    it 'returns an Array' do
      expect(authority.all).to be_a Array
    end
  end
end
