class FilterAdsService

  SELLER_NAME_BLACKLIST = [
    'OKAL Haus Ost'
    'LUKAS Massivhaus GmbH'
    'Argetra GmbH'
    'Jörg Groh'
  ]

  def call
    filter_unsuggested(flats_not_in_berlin)
    filter_unsuggested(small_flats_in_berlin)
    filter_unsuggested(expensive_flats)
    filter_unsuggested(expensive_buildings)
    filter_unsuggested(expensive_properties)
    filter_unsuggested(outdated_ads)
    filter_all(blacklisted_sellers)
  end

  private

  def filter_unsuggested collection
    collection.where(is_ignored: false).where(is_suggested: false).update_all(is_ignored: 1)
  end

  def filter_all collection
    collection.where(is_ignored: false).update_all(is_ignored: 1)
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

  def outdated_ads
    Ad.where('published_at < ?', Time.now - 10 * 24 * 60 * 60).where(is_favorite: false)
  end

  def blacklisted_sellers
    clause = SELLER_NAME_BLACKLIST.map do |str|
      "SUBSTR(seller_name, 1, #{str.length})='#{str}'"
    end.join(' OR ')

    Ad.where(clause)
  end
end
