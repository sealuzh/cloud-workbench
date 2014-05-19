module ApplicationHelper
  def content_header(title, subtitle = '')
    content_for :content_header do
      "<h1>#{title}<small>#{subtitle}</small></h1>".html_safe
    end
  end
end
