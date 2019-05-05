class AppFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(method, options = {})
    errors = @object.errors[method]
    group_classes = ['govuk-form-group', errors.any? ? 'govuk-form-group--error' : nil]
    field_classes = ['govuk-input', errors.any? ? 'govuk-input--error' : nil, options[:class]]

    label = options.delete(:label)
    label = label ? @template.label(@object_name, method, label, class: 'govuk-label') : ''

    hint = options.delete(:hint)
    hint = hint ? @template.content_tag(:span, hint, class: 'govuk-hint') : ''

    @template.content_tag(:div, class: group_classes) do
      @template.concat label
      @template.concat hint
      @template.concat error_message(method)
      @template.concat super(method, options.merge({class: field_classes}))
    end
  end

  def radio_button(method, tag_value, options = {})
    field_classes = ['govuk-radios__input', options[:class]]

    label = options.delete(:label)
    label = label ? @template.label(@object_name, method.to_s + "_" + tag_value, label, class: 'govuk-label govuk-radios__label') : ''

    hint = options.delete(:hint)
    hint = hint ? @template.content_tag(:span, hint, class: 'govuk-hint govuk-radios__hint') : ''

    @template.content_tag(:div, class: 'govuk-radios__item') do
      @template.concat super(method, tag_value, options.merge({class: field_classes}))
      @template.concat label
      @template.concat hint
    end
  end

  def submit(value = nil, options = {})
    super(value, options.merge({class: ['govuk-button', options[:class]]}))
  end

  def error_message(method)
    errors = @object.errors[method]
    if errors.any?
      #TODO better way to get/create id - it might not work for object from array (with index)
      error_id = @object_name + '_' + method.to_s + '-error'
      @template.content_tag :span, id: error_id, class: 'govuk-error-message' do
        errors.each do |e|
          @template.concat @template.content_tag(:span, 'Chyba: ', class: 'govuk-visually-hidden')
          @template.concat e
        end
      end
    else
      ''
    end

  end
end
