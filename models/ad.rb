# t.string :platform, null: false
# t.string :platform_id, null: false
# t.text :url, null: false
# t.float :lat, null: false
# t.float :lon, null: false
# t.boolean :is_ignored, null: false, default: false
# t.boolean :is_favorite, null: false, default: false
# t.boolean :is_suggested, default: false

# t.string :postcode
# t.string :category
# t.string :sub_category
# t.integer :price
# t.integer :hausgeld
# t.boolean :commission
# t.integer :year
# t.integer :flat_sqm
# t.integer :property_sqm
# t.integer :rooms_count
# t.integer :floor

# t.string :seller_name
# t.boolean :seller_is_commercial

# t.integer :price_per_sqm_flat
# t.integer :price_per_sqm_property
# t.integer :price_per_room

class Ad < ActiveRecord::Base
  validates :platform, presence: true
  validates :platform_key, presence: true
  validates :url, presence: true
  validates :lat, numericality: true, allow_nil: true
  validates :lon, numericality: true, allow_nil: true
  validates :postcode, presence: true
  validates :published_at, presence: true

  validates :price, numericality: true, allow_nil: true
  validates :hausgeld, numericality: true, allow_nil: true
  validates :year, numericality: true, allow_nil: true
  validates :flat_sqm, numericality: true, allow_nil: true
  validates :property_sqm, numericality: true, allow_nil: true
  validates :rooms_count, numericality: true, allow_nil: true
  validates :floor, numericality: true, allow_nil: true

  scope :flats, -> { where(category: 'Eigentumswohnungen') }
  scope :properties, -> { where(category: 'Grundstücke & Gärten') }
  scope :buildings, -> { where(category: 'Häuser zum Kauf') }
  scope :in_berlin, -> { where("SUBSTR(postcode, 1, 2) IN ('10', '11', '12', '13')") }
  scope :not_in_berlin, -> { where("SUBSTR(postcode, 1, 2) NOT IN ('10', '11', '12', '13')") }
  scope :with_price_between, ->(min, max) { where("price BETWEEN ? AND ? OR price IS NULL", min, max) }
  scope :with_flat_sqm_between, ->(min, max) { where("flat_sqm BETWEEN ? AND ? OR flat_sqm IS NULL", min, max) }
  scope :with_prop_sqm_between, ->(min, max) { where("property_sqm BETWEEN ? AND ? OR property_sqm IS NULL", min, max) }
  scope :with_rooms_between, ->(min, max) { where("rooms_count BETWEEN ? AND ? OR rooms_count IS NULL", min, max) }
  scope :with_price_per_room_between, ->(min, max) { where("price_per_room BETWEEN ? AND ? OR price_per_room IS NULL", min, max) }
  scope :with_price_per_sqm_prop, -> (min, max) { where("price_per_sqm_property BETWEEN ? AND ? OR price_per_sqm_property IS NULL", min, max) }

  before_save do
    self.url_md5 = Digest::MD5.hexdigest(url)
    self.published_at ||= Time.now

    if price && price > 0
      self.price_per_sqm_property = (price/property_sqm.to_f).ceil if property_sqm && property_sqm > 0
      self.price_per_sqm_flat = (price/flat_sqm.to_f).ceil if flat_sqm && flat_sqm > 0
      self.price_per_room = (price/rooms_count.to_f).ceil if rooms_count && rooms_count > 0
    end
  end

  def global_platform_key
    "#{platform}:#{platform_key}"
  end

  def self.find_or_build_and_assign_attributes attrs
    throw 'Require url attribute' unless attrs[:url]
    ad = find_by_url(attrs[:url]) || new
    ad.assign_attributes attrs
    ad
  end

  def self.find_by_url url
    find_by(url_md5: Digest::MD5.hexdigest(url))
  end
end
