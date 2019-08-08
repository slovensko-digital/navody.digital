module SessionsHelper
  def email_input_tag(content: '', error: false)
    form_group_class = 'govuk-form-group'
    form_group_class += ' govuk-form-group--error' if error

    content_tag :div, class: form_group_class do
      form_group_span1 = content_tag :span, class: 'govuk-label-wrapper' do
        label_tag :email, class: 'govuk-label govuk-label--m' do
          'alebo e-mailom'
        end
      end

      form_group_span2 = content_tag :span, class: 'govuk-hint' do
        'Pošleme Vám jednoduchý odkaz na prihlásenie sa.'
      end

      form_group_span3 = content_tag :span, class: 'govuk-error-message' do
        content_tag(:span, class: 'govuk-visually-hidden') {} + 'Email je neplatný'
      end

      email_field_class = 'govuk-input'
      email_field_class += ' govuk-input--error' if error
      email_field = email_field_tag :email, content, class: email_field_class

      result = form_group_span1 + form_group_span2
      result += form_group_span3 if error
      result += email_field
      result
    end
  end
end
