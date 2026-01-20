class PapersController < ApplicationController
    before_action :set_paper, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    set_tag_search_data(Paper)
    @papers = @items
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @paper = Paper.new # 空っぽのインスタンスを作ってフォームに渡す
  end

  # GET /posts/1/edit
  def edit
    # @post は before_action でセット済み
  end

  # POST /posts
  def create
    # フォームから送られてきたデータ(post_params)でインスタンスを作る
    @paper = Paper.new(paper_params)
    unless check_password_match?
      flash.now[:alert] = "Password incorrect. Cannot create."
      # パスワード不一致なら保存せず、入力画面に戻す
      render :new, status: :unprocessable_entity
      return # ここで処理を終了
    end
    if @paper.save
      # 成功したら詳細画面へリダイレクトし、メッセージを出す
      redirect_to @paper, notice: "Created successfully!"
    else
      # 失敗したら、入力内容を保持したまま「新規作成画面」に戻す
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @paper.update(paper_params)
      redirect_to @paper, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    unless check_password_match?
      redirect_to @paper, alert: "Password incorrect. Cannot delete."
      return
    end
    @paper.destroy
    redirect_to papers_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    def set_paper
      @paper = Paper.find(params[:id])
    end

    def paper_params
      params.require(:paper).permit(:title, :content, content_figures: [])
    end
end
