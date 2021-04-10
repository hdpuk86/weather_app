# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

HeatRating.create!(min_temp: -100, max_temp: 12, name: 'Cold')
HeatRating.create!(min_temp: 13, max_temp: 25, name: 'Warm')
HeatRating.create!(min_temp: 26, max_temp: 100, name: 'Hot')
