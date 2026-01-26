class NewsController < ApplicationController
  before_action :set_news, only: %i[ show edit update destroy ]
  def index
    set_tag_search_data(News)
    @news_list = @items
  end

  def show
  end

  def new
    @news = News.new
  end

  def edit
  end

  def create
    @news = News.new(news_params)

    unless check_password_match?
      flash.now[:alert] = "Password incorrect. Cannot create."
      render :new, status: :unprocessable_entity
      return # ここで処理を終了
    end

    if @news.save
      redirect_to @news, notice: "Created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @news.update(news_params)
      redirect_to @news, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless check_password_match?
      redirect_to @news, alert: "Password incorrect. Cannot delete."
      return
    end
    @news.destroy
    redirect_to news_index_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    def set_news
      puts "Called!!!!!!!!!!!!!!!!!"
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :content, content_figures: [])
    end
end
