module ApplicationHelper
  def display_indicator(indicator_on)
    if indicator_on
      content_tag(:div, "Indicator is ON", class: "indicator-on")
    else
      content_tag(:div, "Indicator is OFF", class: "indicator-off")
    end
  end
end
