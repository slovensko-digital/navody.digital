class AppFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(method, options={})
    has_errors = @object.errors[method].any?

    @template.content_tag(:div, class: 'govuk-form-group' + (has_errors ? ' govuk-form-group--error' : '')) do
      #TODO label as option or parameter?
      @template.label(:label, method, options[:label], class: 'govuk-label') +
        (options[:hint] ? @template.content_tag(:span, options[:hint], class: 'govuk-hint') : '') +
      #TODO better wrapping for errors - see design manual. There should be id. Add span with visually-hidden.
      # Joint with '. ' or repeat span?
        (has_errors ? @template.content_tag(:span, @object.errors[method].join(' '), class: 'govuk-error-message') : '') +
        super(method, options.merge({class: 'govuk-input' + (has_errors ? ' govuk-input--error' : '')}))
      #TODO not use options.merge but objectify_options and other merge possibility for class
    end
  end

end
