class ToolsController < ApplicationController
  before_action :set_tool, only: %i[ show edit update destroy ]

  # GET /tools or /tools.json
  def index
    set_tag_search_data(Tool)
    @tools = @items
  end

  # GET /tools/1 or /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tools = Tool.new
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools or /tools.json
  def create
    # フォームから送られてきたデータ(post_params)でインスタンスを作る
    @tools = Tool.new(tool_params)

    if @tools.save
      # 成功したら詳細画面へリダイレクトし、メッセージを出す
      redirect_to @tools, notice: "Created successfully!"
    else
      # 失敗したら、入力内容を保持したまま「新規作成画面」に戻す
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tools.update(tool_params)
      redirect_to @tools, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @tools.destroy
    redirect_to tools_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tool
      @tools= Tool.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tool_params
      params.require(:tool).permit(:title, :content, content_figures: [])
    end
end
