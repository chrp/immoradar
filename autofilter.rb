require './models'

Ad.where(category: 'Eigentumswohnungen').where('flat_sqm<?', 100).update_all(is_ignored: true)

Ad.where(category: 'Eigentumswohnungen').where('price_per_sqm_flat>=?', 6000).update_all(is_ignored: true)

# Ad.where(sub_category: 'Einfamilienhaus freistehend').where('flat_sqm<?', 100).where('price>?', 900_000).update_all(is_ignored: true)
