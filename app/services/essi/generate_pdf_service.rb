module ESSI
  class GeneratePdfService
    # Generate PDFs for download
    # @param [SolrDocument] resource
    def initialize(resource)
      @resource = resource
      @file_name = "#{@resource.id}.pdf"
    end

    def generate
      file_path = create_pdf_file_path
      generate_pdf_document(file_path)

      { file_path: file_path, file_name: @file_name }
    end

    private

    def dir_path
      Rails.root.join('tmp', 'pdfs')
    end

    def create_pdf_file_path
      file_path = dir_path.join(@file_name)

      FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
      File.delete(file_path) if File.exist?(file_path)
      file_path
    end

    def generate_pdf_document(file_path)
      Prawn::Document.generate(file_path, margin: [0, 0, 0, 0]) do |pdf|
        CoverPageGenerator.new(@resource).apply(pdf)
        create_tmp_files(pdf)
      end
    end

    def create_tmp_files(pdf)
      # TODO Use logical structure if it exists?
      sorted_files = @resource.file_set_ids
      sorted_files.each.with_index(1) do |fs, i|
        fs_solr = SolrDocument.find fs
        uri = Hyrax.config.iiif_image_url_builder.call(fs_solr.original_file_id, nil, '1024,')
        URI.open(uri) do |file|
          page_size = [CoverPageGenerator::LETTER_WIDTH, CoverPageGenerator::LETTER_HEIGHT]
          file.binmode
          pdf.image(file, fit: page_size, position: :center, vposition: :center)
        end
        paginate_images(pdf, i)
      end
    end

    def paginate_images(pdf, i)
      num_of_images = @resource.file_set_ids.size
      pdf.start_new_page unless num_of_images == i
    end
  end
end
