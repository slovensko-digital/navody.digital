class AppFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(method, options = {})
    has_errors = @object.errors[method].present?

    group_classes = ['govuk-form-group']
    group_classes << 'govuk-form-group--error' if has_errors

    field_classes = ['govuk-input', options[:class]]
    field_classes << 'govuk-input--error' if has_errors

    label = options.delete(:label)
    label = label(method, label, class: 'govuk-label') if label

    hint = options.delete(:hint)
    hint = @template.content_tag(:span, hint, class: 'govuk-hint') if hint

    @template.content_tag(:div, class: group_classes) do
      @template.concat label
      @template.concat hint
      @template.concat error_message(method)
      @template.concat super(method, objectify_options(options.merge({class: field_classes})))
    end
  end

  def radio_button(method, tag_value, options = {})
    field_classes = ['govuk-radios__input', options[:class]]

    label = options.delete(:label)
    strong_label = options.delete(:strong_label)
    label_classes = ['govuk-label', 'govuk-radios__label']
    label_classes << 'govuk-label--s' if strong_label
    label = label(method.to_s + "_" + tag_value, label, class: label_classes) if label

    hint = options.delete(:hint)
    hint = @template.content_tag(:span, hint, class: 'govuk-hint govuk-radios__hint') if hint

    @template.content_tag(:div, class: 'govuk-radios__item') do
      @template.concat super(method, tag_value, objectify_options(options.merge({class: field_classes})))
      @template.concat label
      @template.concat hint
    end
  end

  def submit(value = nil, options = {})
    super(value, objectify_options(options.merge({class: ['govuk-button', options[:class]]})))
  end

  def error_message(method)
    errors = @object.errors[method]
    return nil unless errors.any?

    #TODO better way to get/create id - it might not work for object from array (with index)
    error_id = @object_name + '_' + method.to_s + '-error'
    @template.content_tag :span, id: error_id, class: 'govuk-error-message' do
      @template.concat @template.content_tag(:span, 'Chyba: ', class: 'govuk-visually-hidden')
      @template.concat errors.join('. ')
    end
  end
end
