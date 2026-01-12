class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  scope :recent, -> { order(created_at: :desc).limit(3) }
  has_rich_text :body
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
  has_many_attached :content_figures
  self.abstract_class = true

  def self.enable_hashtag_extraction
    acts_as_taggable_on :tags
    before_save :extract_tags_from_body
  end

  private

  def extract_tags_from_body
    # contentがない場合は何もしない
    return if content.blank?

    # ActionTextの中身を文字列として操作するために取得
    # dupして元のオブジェクトを直接壊さないようにする
    processed_content = content.to_s.dup
    found_tags = []

    # ---------------------------------------------------------
    # 1. 移動リンク (Link) の処理: @ 1@ @
    # ---------------------------------------------------------
    # パターン: @ 数字 @ @ (空白は許容)
    # これを先に処理しないと、次の「移動先」の正規表現と干渉する可能性があります
    processed_content = processed_content.gsub(/@\s*(\d+)@\s*@/) do
      num = $1
      # ページ内リンクを作成 (クリックすると #anchor-数字 に飛ぶ)
      # classは見栄え調整用につけています
      %{<a href="#anchor-#{num}" class="anchor-link" style="text-decoration:none; color:blue;">➡ #{num}</a>}
    end

    # ---------------------------------------------------------
    # 2. タグ (Tag) の処理: @@タグ名@@
    # ---------------------------------------------------------
    # パターン: @@ で囲まれた空白以外の文字
    processed_content = processed_content.gsub(/@@([^@\s\n]+)@@/) do
      # $1 にタグ名が入る
      found_tags << $1
      "" # 本文からは削除
    end

    # ---------------------------------------------------------
    # 3. 移動先 (Anchor Point) の処理: @ 1 @
    # ---------------------------------------------------------
    # パターン: @ 数字 @ (数字の前後の空白は許容)
    processed_content = processed_content.gsub(/@\s*(\d+)\s*@/) do
      num = $1
      # id属性をつけた太字(Strong)に置換
      # この id="anchor-数字" めがけてリンクが飛びます
      %{<strong id="anchor-#{num}" class="anchor-point" style="background-color:#ffffcc; padding:2px;">[#{num}]</strong>}
    end
    
    self.tag_list = found_tags.uniq

    # 加工したHTML本文をセット
    # ActionTextはHTML文字列を受け取れます
    self.content = processed_content.strip

    # タグがある場合、末尾にリストを表示
    if self.tag_list.present?
      joined_tags = self.tag_list.map { |t| "##{t}" }.join(" ")
      tag_html = "<hr><h3>Related Tags:</h3><p>#{joined_tags}</p>"
      self.content = "#{self.content}#{tag_html}"
    end
  end
end