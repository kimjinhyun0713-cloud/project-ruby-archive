class NewsController < ApplicationController
  def index
    @title = "Updates"
    @news_list = News.all.order(created_at: :desc)
    @news_list = paginate_item(@news_list)
  end

  def show
    @news = News.find(params[:id])
  end
end
