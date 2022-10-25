module CustomComponentsHelper
  def raw_with_custom_components(html, journey: nil)
    fragment = Nokogiri::HTML.fragment(html)

    fragment.css('embedded-app').each do |elm|
      elm.replace render_embedded_app(elm)
    end

    fragment.css('notification-subscription').each do |elm|
      subscription_types = elm[:types].split(/[,\s]+/)
      elm.replace render_notification_subscription_component(subscription_types, journey: journey, content: elm.inner_html)
    end

    fragment.css('deadline').each do |elm|
      date_info = elm[:time]
      date_info = "#{Date.today.year}-#{date_info}" unless date_info.start_with?(/\d{4}-/)
      deadline = Date.parse(date_info)
      inner_html_selector = deadline > Date.today ? 'before' : 'after'
      elm.replace(render 'components/deadline', time: deadline, past_due: deadline > Date.today, inner_html: elm.css(inner_html_selector).inner_html)
    end

    raw(fragment.to_s)
  end

  private

  def render_embedded_app(fragment)
    app_id = fragment['app-id']
    # TODO why is this hardcoded?
    if app_id == 'narodenie-rodny-list'
      render partial: 'components/embedded_app', locals: {app_id: app_id, template: 'apps/child_birth_app/picking_up_protocol/start'}
    else
      'error'
    end
  end
end
