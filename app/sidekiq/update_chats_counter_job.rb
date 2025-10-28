class UpdateChatsCounterJob
  include Sidekiq::Job
  
  def perform
    # Process applications in batches so we don't run out of memory and burn the server :)
    MyApplication.find_in_batches(batch_size: 100) do |applications|
      update_chats_count_for_batch(applications)
    end
  end
  
  private
  
  def update_chats_count_for_batch(applications)
    application_ids = applications.map(&:id)
    
    chat_counts = Chat
      .where(my_application_id: application_ids)
      .group(:my_application_id)
      .count
    
    applications.each do |application|
      chats_count = chat_counts[application.id] || 0
      application.update_column(:chats_count, chats_count)
    end
  end
end