# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'rake'
Rake::Task['hyrax:default_collection_types:create'].invoke
Rake::Task['hyrax:default_admin_set:create'].invoke

collection_types = Hyrax::CollectionType.all
collection_types.each do |c|
  next unless c.title =~ /^translation missing/
  oldtitle = c.title
  c.title = I18n.t(c.title.gsub("translation missing: en.", ''))
  c.save
  puts "#{oldtitle} changed to #{c.title}"
end