class UpdateMessagesCounterJob
  include Sidekiq::Job
  
  def perform
    # Process chats in batches so we don't run out of memory and burn the server :)
    Chat.find_in_batches(batch_size: 100) do |chats|
      update_messages_count_for_batch(chats)
    end
  end
  
  private
  
  def update_messages_count_for_batch(chats)
    chat_ids = chats.map(&:id)
    
    message_counts = Message
      .where(chat_id: chat_ids)
      .group(:chat_id)
      .count
    
    chats.each do |chat|
      messages_count = message_counts[chat.id] || 0
      chat.update_column(:messages_count, messages_count)
    end
  end
end