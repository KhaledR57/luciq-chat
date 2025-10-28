namespace :es do
    desc "Build elastic index"
    task :build_index => :environment do
      if Elasticsearch::Model.client.indices.exists?(index: Message.index_name)
        Elasticsearch::Model.client.indices.delete(index: Message.index_name)
      end
      Elasticsearch::Model.client.indices.create(index: Message.index_name)
      Message.import
    end
  end