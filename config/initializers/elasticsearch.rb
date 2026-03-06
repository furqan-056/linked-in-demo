if Rails.env.development? || Rails.env.test?
  Searchkick.client = Elasticsearch::Client.new(
    url: ENV.fetch("ELASTICSEARCH_URL", "https://localhost:9200"),
    transport_options: {
      ssl: {
        verify: false
      }
    },
    user: ENV.fetch("ELASTICSEARCH_USERNAME", "elastic"),
    password: ENV.fetch("ELASTICSEARCH_PASSWORD", "")
  )
end
