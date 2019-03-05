class GovukFormBuilder < ActionView::Helpers::FormBuilder
  def govuk_text_field(method, options = {})
    has_errors = @object.errors[method].present?

    group_classes = ['govuk-form-group']
    group_classes << 'govuk-form-group--error' if has_errors

    input_classes = ['govuk-input', options[:class]]
    input_classes << 'govuk-input--error' if has_errors

    @template.content_tag(:div, class: group_classes, id: "form_group_#{method}") do
      @template.concat @template.label(method, options[:label] || @object.class.human_attribute_name(method), class: 'govuk-label')
      @template.concat @template.content_tag(:span, options[:hint], class: 'govuk-hint') if options[:hint].present?
      @template.concat @template.content_tag(:span, @object.errors[method].first, class: 'govuk-error-message') if has_errors
      @template.concat @template.text_field(@object_name, method, objectify_options(options.merge({ class: input_classes })))
    end
  end
end
