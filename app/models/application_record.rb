class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  scope :recent, -> { order(created_at: :desc).limit(3) }
  has_rich_text :body
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
  has_many_attached :content_figures
  self.abstract_class = true

  REGEX_RELATED_TAGS = /<br>Related Tags: /m
  REGEX_AI_TAGS = /AI summary:<br>.*?<br><br>/m

  def self.enable_hashtag_extraction
    acts_as_taggable_on :tags
    before_save :extract_tags_from_body

    # 保存完了後にAI要約ジョブを予約
    after_save_commit :enqueue_summary_job, if: -> { saved_change_to_content? }
  end

  private

  def enqueue_summary_job
    GenerateContentSummaryJob.perform_later(self.id, self.class.name)
  end

  def extract_tags_from_body
    return if content.blank?
    processed_content = content.to_s.dup
    processed_content = processed_content.gsub(REGEX_RELATED_TAGS, "")
    processed_content = processed_content.gsub(REGEX_AI_TAGS, "")
    found_tags = []

    # 1. リンク処理
    processed_content = processed_content.gsub(/@\s*(\d+)@\s*@/) do
      num = $1
      %(<a href="#anchor-#{num}" class="js-scroll-anchor" style="cursor: pointer;"> -> #{num}</a>)
    end

    # 2. アンカー処理
    processed_content = processed_content.gsub(/@\s*(\d+)\s*@/) do
      num = $1
      %(<span id="anchor-#{num}" class="text-anchor-target" style="background-color: #fff0f0;">[#{num}]</span>)
    end

    # 3. タグ抽出
    processed_content = processed_content.gsub(/@([^@\s\n]+)@/) do
      found_tags << $1
      ""
    end

    self.tag_list = found_tags.uniq
    self.content = processed_content.strip

    # タグがある場合、末尾にリストを表示
    if self.tag_list.present?
      joined_tags = self.tag_list.map { |t| "@#{t}@" }.join(" ")
      tag_html = "<br>Related Tags: #{joined_tags}"
      self.content = "#{self.content}#{tag_html}"
    end
  end
end
