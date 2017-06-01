class Evidence < ActiveRecord::Base
  include Publishable
  include BelongsToPhoto
  include UserFields

  attr_accessor :context_photo_id

  belongs_to :book, required: true, inverse_of: :evidence
  belongs_to :context_image, inverse_of: :evidence, counter_cache: true

  has_many :evidence_content_types, dependent: :destroy
  has_many :content_types, through: :evidence_content_types
  accepts_nested_attributes_for :evidence_content_types, allow_destroy: true

  has_many :provenance_agents, dependent: :destroy, inverse_of: :evidence
  has_many :names, through: :provenance_agents
  accepts_nested_attributes_for :provenance_agents, allow_destroy: true,
    reject_if: proc { |attributes| attributes['name_id'].blank? }

  delegate :photos,   to: :book,          prefix: true, allow_nil: true

  delegate :photo,    to: :context_image, prefix: true, allow_nil: true
  delegate :photo_id, to: :context_image, prefix: true, allow_nil: true

  delegate :title,    to: :book,          prefix: true, allow_nil: true
  delegate :author,   to: :book,          prefix: true, allow_nil: true
  delegate :repository,   to: :book,          prefix: true, allow_nil: true
   delegate :owner,   to: :book,          prefix: true, allow_nil: true
  delegate :collection,   to: :book,          prefix: true, allow_nil: true
  delegate :geo_location,   to: :book,          prefix: true, allow_nil: true
  delegate :call_number,   to: :book,          prefix: true, allow_nil: true
  delegate :creation_place,   to: :book,          prefix: true, allow_nil: true
  delegate :creation_date,   to: :book,          prefix: true, allow_nil: true
  delegate :creation_place,   to: :book,          prefix: true, allow_nil: true
  delegate :publisher,   to: :book,          prefix: true, allow_nil: true
  delegate :date_narrative,   to: :book,          prefix: true, allow_nil: true
  delegate :acq_source,   to: :book,          prefix: true, allow_nil: true
  delegate :comment_book,   to: :book,          prefix: true, allow_nil: true






  FORMATS = [
             [ 'Binding',                      'binding' ],
             [ 'Binding Waste',                'binding_waste' ],
             [ 'Bookplate/Label',              'bookplate_label' ],
             [ 'Drawing/Illumination',         'drawing_illumination' ],
             [ 'Inscription',                  'inscription' ],
             [ 'Other paste-in',               'other_paste_in' ],
             [ 'Stamp -- inked',               'stamp_inked' ],
             [ 'Stamp -- blind or embossed',   'stamp_blind_or_embossed' ],
             [ 'Stamp -- perforated',          'stamp_perforated' ],
             [ 'Wax Seal',                     'wax_seal' ],
             [ 'Other Format',                 'other' ],
            ]

  FORMATS_BY_CODE = FORMATS.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  LOCATIONS = [
    [ 'Front Cover',                'front_cover' ],
    [ 'Inside Front Cover',         'inside_front_cover' ],
    [ 'Front Endleaf',              'front_endleaf' ],
    [ 'Title Page',                 'title_page' ],
    [ 'Title Page, Verso',          'title_page_verso' ],
    [ 'Page, Folio, or Signature Number',
                                    'page_number' ],
    [ 'Insertion',                  'insertion' ],
    [ 'Back Endleaf',               'back_endleaf' ],
    [ 'Inside Back Cover',          'inside_back_cover' ],
    [ 'Back Cover',                 'back_cover' ],
    [ 'Spine',                      'spine' ],
    [ 'Head, Tail, Fore Edge',      'head_tail_fore_edge' ],
  ]

  LOCATIONS_BY_CODE = LOCATIONS.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  validates :format, inclusion: { in: FORMATS.map(&:last), message: "'%{value}' is not in list" }
  # validates :book,                  presence: true
  validates :format_other,          presence: true, if: :has_other_format?

  validates :location_in_book, inclusion: { in: LOCATIONS.map(&:last), message: "'%{value}' is not in list", allow_blank: true }
  validates :location_in_book_page, presence: true, if: :located_on_page?

  validates :format_other,          absence: true, unless: :has_other_format?
  validates :location_in_book_page, absence: true, unless: :located_on_page?

  def full_name
    sprintf "%s, %s", (format_name || 'New evidence'), book_full_name
  end
  alias_method :name, :full_name

  def format_name
    return format_other if self.format == 'other_format'
    FORMATS_BY_CODE[self.format]
  end

  def location_name
    return location_in_book_page if location_in_book == 'page_number'
    LOCATIONS_BY_CODE[location_in_book]
  end

  def location_name_without_page
    LOCATIONS_BY_CODE[location_in_book]
  end

  def content_type_names
    content_types.map(&:name)
  end

  def evidence_summary
    [ format_name, content_type_names ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end

  def has_date?
    [ year_when, year_start, year_end ].any? &:present?
  end

  def has_other_format?
    format == 'other'
  end

  def located_on_page?
    location_in_book == 'page_number'
  end

  def date_string
    return nil unless has_date?3
    return year_when.to_s if year_when.present?
    [ year_start, year_end ].join '-'
  end

  def to_s
    format_name
  end

  searchable do

    text :complete_evidence, stored: true do
      fields = [
        format_name,
        location_name,
        transcription,
        date_narrative,
        where,
        comments,
        citations,
        book_title,
        book_author,
        book_owner,
        book_collection,
        book_geo_location,
        book_call_number,
        book_creation_place,
        book_publisher,
        book_date_narrative,
        book_acq_source,
        book_comment_book
      ]
      fields += content_type_names

      fields.map(&:to_s).select(&:present?).join("\n")
    end




    text :format_name
    text :location_name_without_page
    text :transcription



    text :book_title
    text :book_author
    text :book_repository
    text :book_owner
    text :book_collection
    text :book_geo_location
    text :book_call_number
    text :book_creation_place
    text :book_creation_date
    text :book_publisher
    text :book_date_narrative
    text :book_acq_source
    text :book_comment_book


    string :format_name, stored: true
    string :location_name_without_page, stored: true
    string :content_types, multiple: true, stored: true do
      content_types.map &:name
    end



    string :book_title, stored: true
    string :book_author, stored: true
    string :book_repository, stored: true
    string :book_owner, stored: true
    string :book_collection, stored: true
    string :book_geo_location, stored: true
    string :book_call_number, stored: true
    string :book_creation_place, stored: true
    string :book_creation_date, stored: true
    string :book_publisher, stored: true
    string :book_date_narrative, stored: true
    string :book_acq_source, stored: true
    string :book_comment_book, stored: true



    integer :year_when
    integer :year_start

  end
end