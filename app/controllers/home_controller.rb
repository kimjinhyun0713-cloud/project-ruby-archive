# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @news_recent = News.recent
    @post_recent = Post.recent
    @tool_recent = Tool.recent
    @note_recent = Note.recent
    @project_recent = Project.recent
    @paper_recent = Paper.recent
    @tagged = Tool.tagged_with("test")
    Rails.logger.debug "!!!!This is for DEBUG!!!!: #{@news_recent.class.inspect}"
    # @posts = Post.all.order(created_at: :desc)
    # ここに「render :index」という命令が省略されています。
  end
end
