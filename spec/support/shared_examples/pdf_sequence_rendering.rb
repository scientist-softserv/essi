RSpec.shared_examples "pdf sequence rendering" do
  describe "#sequence_rendering" do
    subject do
      presenter.sequence_rendering
    end

    before do
      Hydra::Works::AddFileToFileSet.call(work.file_sets.first,
                                          File.open(fixture_path + '/world.png'), :original_file)
    end

    context 'when pdf_state is downloadable' do
      before do
        work.pdf_state = 'downloadable'
      end
      context 'when user is an admin' do
        before do
          allow(current_user).to receive(:admin?).and_return(true)
        end

        it 'returns a hash containing the pdf rendering information' do
          expect(subject).to be_an Array
          expect(subject).to include(pdf_rendering_hash)
        end
      end

      context 'when user is not an admin' do
        before do
          allow(current_user).to receive(:admin?).and_return(false)
        end

        it 'returns a hash containing the pdf rendering information' do
          expect(subject).to be_an Array
          expect(subject).to include(pdf_rendering_hash)
        end
      end
    end

    context 'when pdf_state is disabled' do
      before do
        work.pdf_state = 'disabled'
      end
      context 'when user is an admin' do
        before do
          allow(current_user).to receive(:admin?).and_return(true)
        end
        it 'returns a hash containing the pdf rendering information' do
          expect(subject).to be_an Array
          expect(subject).to include(pdf_rendering_hash)
        end
      end
      context 'when user is not an admin' do
        before do
          allow(current_user).to receive(:admin?).and_return(false)
        end

        it 'returns a hash without the pdf rendering information' do
          expect(subject).to be_an Array
          expect(subject).not_to include(pdf_rendering_hash)
        end
      end
    end
  end
end
