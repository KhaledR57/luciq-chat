Elasticsearch::Model.client = Elasticsearch::Client.new(
  port: ENV.fetch('ES_PORT') { 9200 },
  host: ENV.fetch('ES_HOST') { 'elasticsearch' },
  retry_on_failure: 3,
  reload_connections: true,
  log: Rails.env.development?,
  transport_options: {
    headers: { content_type: 'application/json' }
  }
)