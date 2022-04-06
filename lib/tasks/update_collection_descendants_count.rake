desc 'Update Collection indexes of descendant counts'
namespace :essi do
  task update_collection_descendant_count: :environment do
    puts 'Updated indexes of collection descendants'
    Collection.search_with_conditions({}, rows: 100_000).each do |c|
      num_works = Collection.subtree_works_for(c.id).count
      num_collections = Collection.subtree_collections_for(c.id).count
      if (num_works != Array.wrap(c['num_works_isi'])&.first.to_i) ||
         (num_collections != Array.wrap(c['num_collections_isi'])&.first.to_i)
        puts c.id
        Collection.find(c.id).save!
      end
    end
    puts 'Completed.'
  end
end
