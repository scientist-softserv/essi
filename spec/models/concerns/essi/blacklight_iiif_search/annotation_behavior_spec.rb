require 'rails_helper'
RSpec.describe BlacklightIiifSearch::AnnotationBehavior do
  let(:parent_id) { 'abc123' }
  let(:file_set_id) { '987654' }
  let(:page_document) do
    SolrDocument.new('id' => file_set_id,
                     'work_id_ssi' => parent_id,
                     'word_boundary_tsi' => boundaries,
                     'has_model_ssim' => ['FileSet'])
  end
  let(:controller) { CatalogController.new }
  let(:boundaries) do
    "{\"width\":null,\"height\":null,\"coords\":{\"software\":[[2641,4102,512,44]]}}"
  end
  let(:parsed_boundaries) do
    JSON.parse(boundaries)
  end
  let(:parent_document) do
    SolrDocument.new('id' => parent_id,
                     'has_model_ssim' => ['PagedResource'])
  end
  let(:iiif_search_annotation) do
    BlacklightIiifSearch::IiifSearchAnnotation.new(page_document, 'software',
                                                   0, nil, controller,
                                                   parent_document)
  end
  let(:test_request) { ActionDispatch::TestRequest.new({}) }

  before { allow(controller).to receive(:request).and_return(test_request) }

  describe '#annotation_id' do
    subject { iiif_search_annotation.annotation_id }
    it 'returns a properly formatted URL' do
      expect(subject).to include("#{parent_id}/manifest/canvas/#{file_set_id}/annotation/0")
    end
  end

  describe '#canvas_uri_for_annotation' do
    before { allow(iiif_search_annotation).to receive(:fetch_and_parse_coords).and_return(parsed_boundaries) }

    subject { iiif_search_annotation.canvas_uri_for_annotation }
    it 'returns a properly formatted URL' do
      expect(subject).to include("#{parent_id}/manifest/canvas/#{file_set_id}")
    end

    describe 'private methods' do
      # test #coordinates based on output of #canvas_uri_for_annotation, which calls it
      describe '#coordinates' do
        it 'gets the expected value from #coordinates' do
          expect(subject).to include("#xywh=2641,4102,512,44")
        end
      end

      describe '#fetch_and_parse_coords' do
        it 'gets the expected Hash for annotation format' do
          expect(iiif_search_annotation.send(:fetch_and_parse_coords)).to eq parsed_boundaries
        end
      end
    end
  end
end
