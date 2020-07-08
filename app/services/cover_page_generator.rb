class CoverPageGenerator # rubocop:disable Metrics/ClassLength
  attr_reader :paged_resource

  # Letter width/height in points for a PDF.
  LETTER_WIDTH = PDF::Core::PageGeometry::SIZES["LETTER"].first
  LETTER_HEIGHT = PDF::Core::PageGeometry::SIZES["LETTER"].last

  def initialize(paged_resource)
    @paged_resource = paged_resource
  end

  def header(prawn_document, header, size: 16)
    Array(header).each do |text|
      prawn_document.move_down 10
      prawn_document.text text,
        { size: size,
        styles: [:bold],
        inline_format: true }
    end
    prawn_document.stroke { prawn_document.horizontal_rule }
    prawn_document.move_down 10
  end

  def text(prawn_document, text)
    Array(text).each do |value|
      prawn_document.text value
    end
    prawn_document.move_down 5
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def apply(prawn_document)
    noto_cjk_b = Rails.root.join('app', 'assets', 'fonts', 'NotoSansCJKtc',
      'NotoSansCJKtc-Bold.ttf')
    noto_cjk_r = Rails.root.join('app', 'assets', 'fonts', 'NotoSansCJK',
      'NotoSansCJKtc-Regular.ttf')
    noto_ara_b = Rails.root.join('app', 'assets', 'fonts', 'NotoNaskhArabic',
      'NotoNaskhArabic-Bold.ttf')
    noto_ara_r = Rails.root.join('app', 'assets', 'fonts', 'NotoNaskhArabic',
      'NotoNaskhArabic-Regular.ttf')
    amiri_b = Rails.root.join('app', 'assets', 'fonts', 'amiri', \
      'amiri-bold.ttf')
    amiri_r = Rails.root.join('app', 'assets', 'fonts', 'amiri', \
      'amiri-regular.ttf')

    prawn_document.font_families.update(
      "amiri" => {
        normal: amiri_r,
        italic: amiri_r,
        bold: amiri_b,
        bold_italic: amiri_b
      },
      "noto_cjk" => {
        normal: noto_cjk_r,
        italic: noto_cjk_r,
        bold: noto_cjk_b,
        bold_italic: noto_cjk_b
      },
      "noto_ara" => {
        normal: noto_ara_r,
        italic: noto_ara_r,
        bold: noto_ara_b,
        bold_italic: noto_ara_b
      }
    )
    prawn_document.fallback_fonts(["noto_cjk", "noto_ara", "amiri"])

    prawn_document.bounding_box([15, LETTER_HEIGHT - 15],
      width: LETTER_WIDTH - 30,
      height: LETTER_HEIGHT - 30) do
      image_path =
        Rails.root.join('app', 'assets', 'images', 'iu-sig-formal.2x.png')
      prawn_document.image(
        image_path.to_s,
        position: :center,
        width: LETTER_WIDTH - 30
      )
      prawn_document.stroke_color "000000"
      prawn_document.move_down(20)
      header(prawn_document, paged_resource.title, size: 24)
      paged_resource.rights_statement.each do |statement|
        text(prawn_document, rights_statement_label(statement))
      end
      prawn_document.move_down 20

      header(prawn_document, "Indiana University Disclaimer")
      prawn_document.text(I18n.t('rights.pdf_boilerplate'),
        inline_format: true)
      prawn_document.move_down 20

      header(prawn_document, "Holding Location")
      text(prawn_document, paged_resource.holding_location)
      prawn_document.move_down 20

      header(prawn_document, "Identifier")
      paged_resource.identifier.each do |identifier|
        text(prawn_document, identifier)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def rights_statement_label(statement)
    Hyrax::RightsStatementService.new.label(statement)
  end

end
