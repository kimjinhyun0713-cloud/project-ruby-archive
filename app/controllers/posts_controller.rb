class PostsController < ApplicationController
  # 共通処理: show, edit, update, destroy の前には必ず「対象の投稿」を特定する
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    set_tag_search_data(Post)
    @posts = @items
  end

  # GET /posts/1
  def show
    # @post は before_action でセット済みなので書かなくてOK
  end

  # GET /posts/new
  def new
    @post = Post.new # 空っぽのインスタンスを作ってフォームに渡す
  end

  # GET /posts/1/edit
  def edit
    # @post は before_action でセット済み
  end

  # POST /posts
  def create
    # フォームから送られてきたデータ(post_params)でインスタンスを作る
    @post = Post.new(post_params)
    unless check_password_match?
      flash.now[:alert] = "Password incorrect. Cannot create."
      # パスワード不一致なら保存せず、入力画面に戻す
      render :new, status: :unprocessable_entity
      return # ここで処理を終了
    end
    if @post.save
      # 成功したら詳細画面へリダイレクトし、メッセージを出す
      redirect_to @post, notice: "Created successfully!"
      Rails.logger.debug "!!!#{@post.content_figures}!!!!!!"
    else
      # 失敗したら、入力内容を保持したまま「新規作成画面」に戻す
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    unless check_password_match?
      redirect_to @post, alert: "Password incorrect. Cannot delete."
      return
    end
    @post.destroy
    redirect_to posts_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, content_figures: [])
    end
end
