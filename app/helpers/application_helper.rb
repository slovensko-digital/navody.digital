module ApplicationHelper
  def build_page_title(title, category = nil)
    [title, category, 'Návody.Digital'].compact.join(' | ')
  end

  def decide_searchable_path(searchable)
    return app_path(searchable.slug) if searchable.is_a? App

    journey_path(searchable.slug)
  end

  def build_step_page_title(step)
    build_page_title(step.custom_title.presence || step.title, step.journey.custom_title.presence || step.journey.title)
  end

  def build_journey_page_title(journey)
    build_page_title(journey.custom_title.presence || journey.title)
  end
end
