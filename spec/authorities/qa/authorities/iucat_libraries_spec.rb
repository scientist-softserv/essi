require 'rails_helper'

RSpec.describe Qa::Authorities::IucatLibraries do
  let(:authority) { described_class.new }
  let(:matching_id) { 'B-WELLS' }
  let(:supplemental_id) { 'B-MEDIASCHOOL' }
  let(:nonmatching_id) { 'foobar' }
  let(:invalid_id) { 'B-WELLS and more' }
  let(:api_enabled) { { url: 'https://iucat.iu.edu/api/library',
                       api_enabled: true } }
  let(:api_disabled) { { url: 'http://some_unreachable_server',
                       api_enabled: false } }
  let(:supplemental_data) { authority.supplemental_data }

  context 'when configuration does not exist' do
    before do
      allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(nil)
    end
    let(:result) { authority.all }
    context 'with supplemental data' do
      describe '#all' do
        it 'returns only supplemental data' do
          expect(result).to be_a Array
          expect(result).not_to be_empty
          expect(result.size).to eq 5
        end
      end
    end
    context 'without supplemental data' do
      before do
        allow(authority).to receive(:supplemental_data).and_return([])
      end
      describe '#all' do
        it 'returns an empty Array' do
          expect(result).to be_a Array
          expect(result).to be_empty
        end
      end
    end
  end

  context 'when api is disabled' do
    before do
      allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_disabled)
      expect(ESSI.config[:iucat_libraries][:api_enabled]).to_not be_truthy
    end
    let(:result) { authority.all }
    context 'with supplemental data' do
      describe '#all' do
        it 'returns only supplemental data' do
          expect(result).to be_a Array
          expect(result).not_to be_empty
          expect(result.size).to eq 5
        end
      end
    end
    context 'without supplemental data' do
      before do
        allow(authority).to receive(:supplemental_data).and_return([])
      end
      describe '#all' do
        it 'returns an empty Array' do
          expect(result).to be_a Array
          expect(result).to be_empty
        end
      end
    end
  end

  context 'with server response', vcr: { cassette_name: 'iucat_libraries_up', record: :new_episodes } do
    describe '#all' do
      let(:result) { authority.all }
      it 'returns a populated Array' do
        allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
        expect(result).to be_a Array
        expect(result).not_to be_empty
      end
    end

    describe '#find' do
      context 'with a matching id in the API' do
        let(:result) { authority.find(matching_id) }
        it 'returns a Hash' do
          allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
          expect(result).to be_a Hash
          expect(result).not_to be_empty
        end
      end
      context 'with a matching id in the supplemental data' do
        let(:result) { authority.find(supplemental_id) }
        it 'returns a Hash' do
          allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
          expect(result).to be_a Hash
          expect(result).not_to be_empty
        end
      end
      context 'with a non-matching id' do
        let(:result) { authority.find(nonmatching_id) }
        it 'returns an empty Hash' do
          allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
          expect(result).to be_a Hash
          expect(result).to be_empty
        end
      end
      context 'with an invalid id' do
        let(:result) { authority.find(invalid_id) }
        it 'returns an empty Hash' do
          allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
          expect(result).to be_a Hash
          expect(result).to be_empty
        end
      end
    end

    describe '#search' do
      before do
        allow(ESSI.config).to receive(:[]).with(:iucat_libraries).and_return(api_enabled)
      end
      context 'with a matching id in the API ' do
        let(:result) { authority.search(matching_id) }
        it 'returns a populated Array' do
          expect(result).to be_a Array
          expect(result).not_to be_empty
        end
      end
      context 'with a matching id in the supplemental data ' do
        let(:result) { authority.search(supplemental_id) }
        it 'returns a populated Array' do
          expect(result).to be_a Array
          expect(result).not_to be_empty
        end
      end
      context 'with a non-matching id' do
        let(:result) { authority.search(nonmatching_id) }
        it 'returns an empty Array' do
          expect(result).to be_a Array
          expect(result).to be_empty
        end
      end
    end
  end
end
