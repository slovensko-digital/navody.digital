module ApplicationHelper
  def build_page_title(title, category = nil)
    [title, category, 'Návody.Digital'].compact.join(' | ')
  end

  def check_box_with_action(path, is_checked, **options, &block)
    form_options = { method: :post, local: true }
                     .merge(options)
                     .merge(url: path)

    form_with(form_options) do |form|
      concat form.check_box(:checkbox, onChange: 'this.form.submit()', class: 'govuk-checkboxes__input', checked: is_checked)
      concat capture(form, &block)
    end
  end
end
