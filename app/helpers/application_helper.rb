module ApplicationHelper

  def headers
    render "shared/headers"
  end

  def buttons
    render "shared/buttons"
  end

  def link_to_with_highlight(name, options = {}, html_options = {})
    html_options.merge!({ :class => 'ui-btn-active' }) if current_page?(options)
    link_to(name, options, html_options)
  end

  def title(text, &block)
    buttons = ""
    buttons = %{<div class="buttons">#{capture(&block)}</div>} if block_given?

    %{<div id="title_block">
        <h1>#{text}</h1>
        #{buttons}
      </div>}.html_safe
  end

  def chart_tag(url)
    image_tag chart_path(:url => url)
  end

end
