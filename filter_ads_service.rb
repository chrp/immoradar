class FilterAdsService
  def call
    filter(flats_not_in_berlin)
    filter(small_flats_in_berlin)
    filter(expensive_flats)
    filter(expensive_buildings)
    filter(expensive_properties)
  end

  private

  def filter collection
    collection.where(is_suggested: false).update(is_ignored: 1)
  end

  def flats_not_in_berlin
    Ad.flats.not_in_berlin
  end

  def small_flats_in_berlin
    Ad.flats.in_berlin.where('flat_sqm < ?', 90)
  end

  def expensive_flats
    Ad.flats.where('price_per_sqm_flat > ?', 6500)
  end

  def expensive_buildings
    Ad.buildings.where('price > ?', 2_220_000)
  end

  def expensive_properties
    Ad.properties.where('price > ?', 900_000)
  end
end
