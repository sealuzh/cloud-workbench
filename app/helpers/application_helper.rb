# frozen_string_literal: true

module ApplicationHelper
  def content_header(title, subtitle = '')
    content_for :content_header do
      "<h1>#{title}<small>#{subtitle}</small></h1>".html_safe
    end
  end

  def actives_badge(count)
    "<small class='badge badge-total pull-right bg-green'>#{count}</small>".html_safe
  end
end
