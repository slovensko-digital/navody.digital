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

  def nested_hidden_fields_for(item, root: nil)
    if item.is_a? Hash
      item.map { |key, value| nested_hidden_fields_for(value, root: hash_key(key, root)) }.join

    elsif item.is_a? Array
      item.map { |e| nested_hidden_fields_for(e, root: "#{root}[]") }.join

    else
      hidden_field_tag(root, item, :id => nil)

    end.html_safe
  end

  def hash_key(item, root)
    return item if root.blank?

    item, root = [item, root].map(&:to_s).map(&:strip)
    first_bracket = item.index('[') || item.length

    wrapped = "[#{item[0...first_bracket]}]"
    untouched = item[first_bracket..-1] || ''

    root << wrapped << untouched
  end
end
