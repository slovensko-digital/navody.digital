class GovukFormBuilder < ActionView::Helpers::FormBuilder
  def govuk_text_field(method, options = {})
    group_classes = ['govuk-form-group']
    group_classes << 'govuk-form-group--error' if @object.errors[method].present?

    input_classes = ['govuk-input', options[:class]]
    input_classes << 'govuk-input--error' if @object.errors[method].present?

    @template.content_tag(:div, class: group_classes, id: "form_group_#{method}") do
      @template.concat @template.label(method, @object.class.human_attribute_name(method), class: 'govuk-label')
      @template.concat @template.content_tag(:span, options[:hint], class: 'govuk-hint')
      @template.concat @template.content_tag(:span, @object.errors[method].first, class: 'govuk-error-message')
      @template.concat @template.text_field(@object_name, method, objectify_options(options.merge({ class: input_classes })))
    end
  end
end
