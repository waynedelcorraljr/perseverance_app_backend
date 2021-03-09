# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
sol = Earthdate.create(date: "2021-01-18", total_photos: 10)

photo = Photo.create(sol: 0, status: "active", img_src: "https://mars.nasa.gov/mars2020-raw-images/pub/ods/surface/sol/00000/ids/edr/browse/edl/ESF_0000_0666965708_609ECM_N0010052EDLC00000_0000LUJ02_1200.jpg", earth_date: "2021-01-18", earthdate_id: 1)
