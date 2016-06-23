class Book < ActiveRecord::Base
  include UserFields

  has_many :photos, dependent: :destroy, inverse_of: :book
  has_many :title_pages, dependent: :destroy, inverse_of: :book
  has_many :evidence, dependent: :destroy, inverse_of: :book

  validates_presence_of :title
  accepts_nested_attributes_for :title_pages

  def holder
    return repository if repository.present?
    owner
  end

  def photos_queued
    photos.queued.count
  end

  def photos_hidden
    photos.unqueued.count
  end

  def all_queued?
    photos_hidden == 0
  end

  def queued_photos
    photos.queued if photos.present?
  end

  def publishables
    title_pages.active + evidence.active
  end

  def full_name
    [ repository, call_number ].flat_map { |s|
      s.present? ? s : []
    }.join ' '
  end
  alias :full_call_number :full_name

  def volume_name
    return nil unless vol_number.present?
    return vol_number if vol_number =~ /v\.|vol/i
    "Vol. #{vol_number}"
  end

  def full_title
    [ title, vol_number ].flat_map { |s| s.present? ? s : [] }.join ', '
  end
  alias_method :name, :full_title

  def publication_info?
    [ creation_place, creation_date, publisher ].any? &:present?
  end

  def publication_info
    [ publisher, creation_place, creation_date ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end

  def publishable?
    return false if processing?
    publishables.any? &:publishable?
  end

  def unpublishable?
    return false if processing?
    on_flickr?
  end

  def on_flickr?
    publishables.any? &:on_flickr?
  end

  def processing?
    publishables.any? &:processing?
  end

  def publish!
    publishables.each { |item| item.publish! }
  end

  def to_s
    full_call_number
  end
end
