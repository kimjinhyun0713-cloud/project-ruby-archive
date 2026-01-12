class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def paginate_item(resource)
    resource.page(params[:page]).per(5)
  end

  def set_tag_search_data(model_class)
    # 1. ベースとなるクエリの作成（タグ絞り込み or 全件）
    base_query = if params[:tag].present?
                   # タグ検索時
                   model_class.tagged_with(params[:tag])
                 else
                   model_class.all.order(created_at: :desc)
                 end

    # 2. ページネーションの適用
    # ここで既存の paginate_item を再利用します
    @items = paginate_item(base_query)

    # 3. ビュー表示用のタイトル設定
    @search_title = if params[:tag].present?
                      "##{params[:tag]} の検索結果"
                    else
                      "すべての#{model_class.model_name.human}" # モデルの日本語名などを表示
                    end

    # 4. サイドバー用の全タグ一覧取得
    @all_tags = model_class.tag_counts_on(:tags).order('count DESC')
  end
end