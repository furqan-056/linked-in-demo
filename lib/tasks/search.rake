namespace :search do
  desc 'Reindex all jobs in Elasticsearch'
  task reindex: :environment do
    puts 'Reindexing Jobs...'
    Job.reindex
    puts "Done! #{Job.search_index.total_docs} jobs indexed."
  end
end
