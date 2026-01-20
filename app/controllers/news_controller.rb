class NewsController < ApplicationController
  def index
    # set_tag_search_data(News)
    @news_list = paginate_item(News.all.order(created_at: :desc))
  end

  def show
    @news = News.find(params[:id])
  end

  def news_list
    @news_list
  end
end
