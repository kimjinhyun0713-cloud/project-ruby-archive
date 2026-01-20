module ApplicationHelper
  def btn_link_to(title, path, bg_color: "#999", color: "#000", **kwargs)
    style_option = "background-color: #{bg_color};"
    style_option += "color: #{color};"

    if kwargs[:style].present?
      style_option += kwargs[:style]
    end

    options = kwargs.merge(class: "custom-btn #{kwargs[:class]}", style: style_option)

    # 4. Rails標準の link_to を呼ぶ
    link_to title, path, options
  end
end
