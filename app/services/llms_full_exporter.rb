class LlmsFullExporter
  include Rails.application.routes.url_helpers

  PROJECT_TITLE = 'Návody.Digital'.freeze
  PROJECT_SUMMARY = 'Interaktívne návody, ako vybaviť slovenské úradné záležitosti elektronicky.'.freeze

  def initialize(output_path: Rails.root.join('public', 'llms-full.txt'), generated_at: Time.current)
    @output_path = Pathname(output_path)
    @generated_at = generated_at
  end

  def call
    output_path.dirname.mkpath
    output_path.write(render)
    output_path
  end

  def render
    <<~XML
      <project title="#{xml_escape(PROJECT_TITLE)}" summary="#{xml_escape(PROJECT_SUMMARY)}">
      <docs>
      #{documents.join("\n")}
      </docs>
      </project>
    XML
  end

  private

  attr_reader :generated_at, :output_path

  def documents
    [overview_document] + category_documents + page_documents + faq_documents + journey_documents + step_documents + quick_tip_documents
  end

  def overview_document
    build_document(
      title: 'Prehľad webu',
      url: root_url(**url_options),
      desc: PROJECT_SUMMARY,
      body: <<~TEXT
        Návody.Digital je web s interaktívnymi návodmi na slovenské úrady a e-služby.

        Vygenerované: #{generated_at.iso8601}
        Základná URL: #{root_url(**url_options)}

        Verejný obsah:
        - Kategórie: #{categories.size}
        - Stránky: #{pages.size}
        - FAQ: #{faqs.size}
        - Návody: #{journeys.size}
        - Kroky: #{steps.size}
        - Rýchle tipy: #{quick_tips.size}
      TEXT
    )
  end

  def category_documents
    categories.map do |category|
      build_document(
        title: "Kategória: #{category.name}",
        url: category_url(category, **url_options),
        desc: excerpt(category.description),
        body: <<~TEXT
          Názov: #{category.name}

          Popis:
          #{text_from_markup(category.description)}
        TEXT
      )
    end
  end

  def page_documents
    pages.map do |page|
      build_document(
        title: page.title,
        url: page_url(page, **url_options),
        desc: page.short_description.presence || excerpt(page.content),
        body: <<~TEXT
          Typ: Stránka
          Názov: #{page.title}

          Obsah:
          #{text_from_markup(page.content)}
        TEXT
      )
    end
  end

  def faq_documents
    faqs.map do |page|
      build_document(
        title: "FAQ: #{page.title}",
        url: faq_url(page, **url_options),
        desc: excerpt(page.content),
        body: <<~TEXT
          Typ: Častá otázka
          Otázka: #{page.title}

          Odpoveď:
          #{text_from_markup(page.content)}
        TEXT
      )
    end
  end

  def journey_documents
    journeys.map do |journey|
      step_lines = journey.steps.map do |step|
        "- #{step.title}: #{journey_step_url(journey, step, **url_options)}"
      end

      build_document(
        title: "Návod: #{journey.title}",
        url: journey_url(journey, **url_options),
        desc: journey.short_description,
        body: <<~TEXT
          Typ: Návod
          Názov: #{journey.title}

          Krátky popis:
          #{journey.short_description}

          Popis:
          #{text_from_markup(journey.description)}

          Kroky:
          #{step_lines.join("\n")}
        TEXT
      )
    end
  end

  def step_documents
    steps.map do |step|
      task_lines = step.tasks.map do |task|
        line = "- #{task.title}"
        line = "#{line}: #{task.url}" if task.url.present?
        line
      end

      body = [
        'Typ: Krok',
        "Návod: #{step.journey.title}",
        "Krok: #{step.title}",
        '',
        'Popis:',
        text_from_markup(step.description)
      ]

      if task_lines.any?
        body << ''
        body << 'Úlohy:'
        body << task_lines.join("\n")
      end

      build_document(
        title: "Krok: #{step.journey.title} / #{step.title}",
        url: journey_step_url(step.journey, step, **url_options),
        desc: excerpt(step.description),
        body: body.join("\n")
      )
    end
  end

  def quick_tip_documents
    quick_tips.map do |quick_tip|
      context = [quick_tip.journey&.title, quick_tip.step&.title].compact.join(' / ')
      build_document(
        title: "Rýchly tip: #{quick_tip.title}",
        url: quick_tip_url(quick_tip, **url_options),
        desc: excerpt(quick_tip.body),
        body: <<~TEXT
          Typ: Rýchly tip
          Názov: #{quick_tip.title}
          #{"Kontext: #{context}" if context.present?}

          Obsah:
          #{text_from_markup(quick_tip.body)}
        TEXT
      )
    end
  end

  def build_document(title:, url:, body:, desc: nil)
    attributes = [
      %(title="#{xml_escape(title)}"),
      %(url="#{xml_escape(url)}")
    ]
    attributes << %(desc="#{xml_escape(desc)}") if desc.present?

    <<~XML.strip
      <doc #{attributes.join(' ')}>
      #{xml_escape(body.strip)}
      </doc>
    XML
  end

  def categories
    @categories ||= Category.order(featured: :desc, featured_position: :asc, name: :asc, id: :asc).to_a
  end

  def pages
    @pages ||= Page.where(is_faq: false).order(position: :asc, id: :asc).to_a
  end

  def faqs
    @faqs ||= Page.faq.order(position: :asc, id: :asc).to_a
  end

  def journeys
    @journeys ||= Journey.accessible_by_url.includes(steps: :tasks).order(title: :asc, id: :asc).to_a
  end

  def steps
    @steps ||= journeys.flat_map(&:steps)
  end

  def quick_tips
    @quick_tips ||= QuickTip.where.not(slug: [nil, '']).order(title: :asc, id: :asc).to_a
  end

  def excerpt(markup, length: 220)
    text = text_from_markup(markup)
    return text if text.length <= length

    "#{text[0, length].rstrip}..."
  end

  def text_from_markup(markup)
    fragment = Nokogiri::HTML.fragment(markup.to_s)

    fragment.css('br').each do |node|
      node.replace(Nokogiri::XML::Text.new("\n", fragment.document))
    end

    fragment.css('li').each do |node|
      node.replace(Nokogiri::XML::Text.new("- #{node.text.strip}\n", fragment.document))
    end

    fragment.css('p,div,section,article,tr,blockquote,h1,h2,h3,h4,h5,h6').each do |node|
      node.replace(Nokogiri::XML::Text.new("#{node.text.strip}\n\n", fragment.document))
    end

    fragment.text
            .gsub("\u00A0", ' ')
            .gsub(/[ \t]+\n/, "\n")
            .gsub(/\n{3,}/, "\n\n")
            .gsub(/[ \t]{2,}/, ' ')
            .strip
  end

  def url_options
    @url_options ||= Rails.application.config.action_mailer.default_url_options.symbolize_keys.compact
  end

  def xml_escape(value)
    ERB::Util.html_escape(value.to_s)
  end
end
