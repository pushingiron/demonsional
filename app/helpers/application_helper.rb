module ApplicationHelper
  def display_indicator(indicator_on)
    content_tag(:div, '', class: 'indicator-off bg-danger rounded-circle', style: 'width: 20px; height: 20px;')
    if indicator_on
      content_tag(:div, '', class: 'indicator-on bg-success rounded-circle', style: 'width: 20px; height: 20px;')
    else
      content_tag(:div, '', class: 'indicator-off bg-danger rounded-circle', style: 'width: 20px; height: 20px;')
    end
  end
end
