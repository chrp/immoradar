class Ads < ActiveRecord::Migration[5.2]
  def change
    create_table :ads do |t|
      t.string :platform, null: false
      t.string :platform_key, null: false
      t.text :url, null: false
      t.string :url_md5, null: false, index: true
      t.float :lat, index: true
      t.float :lon, index: true
      t.boolean :is_ignored, null: false, default: false, index: true
      t.boolean :is_favorite, null: false, default: false, index: true
      t.datetime :published_at, null: false, index: true

      t.string :postcode, null: false
      t.string :category
      t.string :sub_category
      t.integer :price
      t.integer :hausgeld
      t.boolean :has_commission
      t.integer :year
      t.integer :flat_sqm
      t.integer :property_sqm
      t.integer :rooms_count
      t.integer :floor

      t.integer :price_per_sqm_flat
      t.integer :price_per_sqm_property
      t.integer :price_per_room

      t.timestamps
    end
  end
end
