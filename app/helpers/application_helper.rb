module ApplicationHelper
  def build_page_title(title, category = nil)
    [title, category, 'Návody.Digital'].compact.join(' | ')
  end

  def build_step_page_title(step)
    build_page_title(step.custom_title.presence || step.title, step.journey.custom_title.presence || step.journey.title)
  end

  def build_journey_page_title(journey)
    build_page_title(journey.custom_title.presence || journey.title)
  end

  def sanitize_description(description, length: 500)
    truncate(strip_tags(description), length: length)
  end

  def dont_show_small_search_bar?
    current_page?(root_path) || current_page?(search_path)
  end

  def localize_boolean(value)
    value.to_s.in?(['1', 'true']) ? 'Áno' : 'Nie'
  end

  alias :lb :localize_boolean
end
