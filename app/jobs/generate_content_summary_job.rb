class GenerateContentSummaryJob < ApplicationJob
  queue_as :default

  def perform(record_id, model_class_name)    
    model_class = model_class_name.constantize
    record = model_class.find_by(id: record_id)
    return unless record

    return if record.content.blank?

    clean_content = record.content.to_s.dup
    client = OpenaiClient.new
    summary = client.content_summary(clean_content, language: "japanese")
    
    return if summary.blank?

    current_content = record.reload.content.to_s
    new_content = "AI summary:<br>#{summary}<br><br>" + current_content
    record.update_column(:content, new_content)
  end
end