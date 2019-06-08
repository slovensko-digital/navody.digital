module StepsHelper
  # <embedded_app url="URL" button="Zodpovedať kto vyzdvihne rodný list" />
  def replace_embedded_app(description)
    # FIXME this should be more sophisticated
    description.gsub(/<embedded_app url="(.+)" button="(.+)" \/>/) do
      match = Regexp.last_match

      render_embedded_app(match[1], match[2])
    end.html_safe
  end

  def render_embedded_app(start_app_url = '', button_name = '')
    render(
      partial: 'steps/embedded_question',
      locals: {
        button_name: button_name,
        start_app_url: start_app_url
      }
    )
  end
end
