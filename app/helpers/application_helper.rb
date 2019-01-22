module ApplicationHelper
  def build_page_title(title, category = nil)
    [title, category, 'Návody.Digital'].compact.join(' | ')
  end
end
