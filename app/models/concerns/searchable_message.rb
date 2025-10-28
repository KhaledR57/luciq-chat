module SearchableMessage
    extend ActiveSupport::Concern
  
    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks
        
        settings index: { number_of_shards: 1 } do
            mappings dynamic: false do
                # the chat_id must be of the keyword type since we're only going to use it to filter messages.
                indexes :chat_id, type: :keyword
                indexes :body, type: :text, analyzer: :english
            end
        end

      def self.search(chat_id, query)
          params = {
              query: {
                bool: {
                  must: [
                    { term: { chat_id: chat_id } },
                    { 
                      match: {
                        body: {
                          query: query,
                          fuzziness: 'AUTO',
                          operator: 'and'
                        }
                      }
                    }
                  ]
                }
              },
            }

            self.__elasticsearch__.search(params).records
      end
  end
end

