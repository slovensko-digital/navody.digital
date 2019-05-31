module ApplicationHelper
  def build_page_title(params, category = nil)
    unless params[1].blank?
      params[1]
    else
      [params[0], category, 'Navody.digital'].compact.join(' | ')
    end
  end
end
