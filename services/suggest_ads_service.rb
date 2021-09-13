class SuggestAdsService
  def call
    suggest(one_family_flats)
    suggest(one_family_properties)
    suggest(one_family_buildings_in_berlin)
    suggest(one_family_buildings_everywhere)
    suggest(two_family_flats)
    suggest(two_family_properties_in_berlin)
    suggest(two_family_properties_everywhere)
    suggest(two_family_buildings)
    suggest(multi_family_properties_in_berlin)
    suggest(multi_family_properties_everywhere)
    suggest(multi_family_buildings)
  end

  private

  def suggest collection
    collection.update_all(is_suggested: 1)
  end

  def one_family_flats
    Ad.flats
      .in_berlin
      .with_price_between(30_000, 555_000)
      .with_rooms_between(3, 99)
      .with_flat_sqm_between(90, 1000)
  end

  def one_family_properties
    Ad.properties
      .in_berlin
      .with_price_between(10_000, 303_000)
      .with_prop_sqm_between(300, 10_000)
  end

  def one_family_buildings_in_berlin
    Ad.buildings
      .in_berlin
      .with_price_between(10_000, 555_000)
      .with_rooms_between(3, 99)
      .with_flat_sqm_between(90, 1000)
  end

  def one_family_buildings_everywhere
    Ad.buildings
      .not_in_berlin
      .with_price_between(10_000, 355_000)
      .with_rooms_between(3, 99)
      .with_flat_sqm_between(90, 1000)
  end

  def two_family_flats
    Ad.flats
      .in_berlin
      .with_price_between(555_000, 915_000)
      .with_rooms_between(6, 99)
      .with_flat_sqm_between(180, 1000)
  end

  def two_family_properties_in_berlin
    Ad.properties
      .in_berlin
      .with_price_between(50_000, 455_000)
      .with_prop_sqm_between(300, 10_000)
  end

  def two_family_properties_everywhere
    Ad.properties
      .not_in_berlin
      .with_price_between(10_000, 255_000)
      .with_prop_sqm_between(500, 10_000)
  end

  def two_family_buildings
    Ad.buildings
      .with_price_between(10_000, 915_000)
      .with_rooms_between(4, 99)
      .with_flat_sqm_between(180, 1000)
  end

  def multi_family_properties_in_berlin
    Ad.properties
      .with_prop_sqm_between(600, 100_000)
      .with_price_between(50_000, 2_220_000)
      .with_price_per_sqm_prop(1, 1_000)
  end

  def multi_family_properties_everywhere
    Ad.properties
      .not_in_berlin
      .with_prop_sqm_between(800, 100_000)
      .with_price_between(50_000, 1_220_000)
      .with_price_per_sqm_prop(1, 500)
  end

  def multi_family_buildings
    Ad.buildings
      .with_price_per_room_between(1, 140_000)
      .with_rooms_between(7, 99)
  end


end

# Ad.where(category: 'Eigentumswohnungen').where('flat_sqm<?', 100).update_all(is_ignored: true)

# Ad.where(category: 'Eigentumswohnungen').where('price_per_sqm_flat>=?', 6000).update_all(is_ignored: true)

# Ad.where(sub_category: 'Einfamilienhaus freistehend').where('flat_sqm<?', 100).where('price>?', 900_000).update_all(is_ignored: true)
