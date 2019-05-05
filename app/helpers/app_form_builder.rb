class AppFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(method, options={})
    errors = @object.errors[method]
    group_classes = ['govuk-form-group', errors.any? ? 'govuk-form-group--error' : nil]
    field_classes = ['govuk-input', errors.any? ? 'govuk-input--error': nil, options[:class]]

    label = options.delete(:label)
    label = label ? @template.label(@object_name, method, label, class: 'govuk-label') : ''

    hint = options.delete(:hint)
    hint = hint ? @template.content_tag(:span, hint, class: 'govuk-hint') : ''

    #TODO better way to get/create id - it might not work for object from array (with index)
    error_id = @object_name + '_' + method.to_s + '-error'
    errors_msg = @template.content_tag :span, id: error_id, class: 'govuk-error-message' do
      errors.each do |e|
        @template.concat @template.content_tag(:span, 'Chyba: ', class: 'govuk-visually-hidden')
        @template.concat e
      end
    end

    @template.content_tag(:div, class: group_classes) do
      @template.concat label
      @template.concat hint
      @template.concat errors.any? ? errors_msg : ''
      @template.concat super(method, options.merge({class: field_classes}))
    end
  end

end
