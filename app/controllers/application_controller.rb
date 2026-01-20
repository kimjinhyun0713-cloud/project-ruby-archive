class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  helper_method :check_password_match?
  private
  def check_password_match?
    params[:admin_password] == ENV["ADMIN_PASSWORD"]
  end

  def paginate_item(resource)
    resource.page(params[:page]).per(5)
  end

  def set_tag_search_data(model_class)
    base_query =
      if params[:tag].present?
        model_class.tagged_with(params[:tag])
      else
        model_class.all.order(created_at: :desc)
      end

    @items = paginate_item(base_query)

    @search_title =
      if params[:tag].present?
        "Search results: # #{params[:tag]}"
      else
        "All #{model_class.model_name.human}"
      end

    @all_tags = model_class.tag_counts_on(:tags).order("count DESC")
  end
end
