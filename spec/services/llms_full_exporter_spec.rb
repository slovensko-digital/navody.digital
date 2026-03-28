require 'rails_helper'

RSpec.describe LlmsFullExporter do
  describe '#call' do
    let(:output_path) { Rails.root.join('tmp', 'llms-full-spec.txt') }
    let(:generated_at) { Time.zone.parse('2026-03-28 10:00:00') }

    before do
      File.delete(output_path) if File.exist?(output_path)
    end

    after do
      File.delete(output_path) if File.exist?(output_path)
    end

    it 'writes a context export with public content and urls' do
      create(:category, name: 'Rodina', description: '<p>Rodinné záležitosti</p>', featured_position: 1)
      create(:page, title: 'Kontakt', slug: 'kontakt', content: '<p>Obsah & detail</p>', short_description: 'Kontakt na tím')
      create(:page, :faq, title: 'Ako to funguje?', slug: 'ako-to-funguje', content: '<p>Jednoducho</p>', position: 99)

      journey = create(
        :journey,
        title: 'Narodenie dieťaťa',
        slug: 'narodenie-dietata',
        short_description: 'Čo vybaviť po narodení dieťaťa',
        description: '<p>Najdôležitejšie povinnosti po narodení.</p>'
      )
      step = create(
        :step,
        journey: journey,
        title: 'Návšteva matriky',
        slug: 'navsteva-matriky',
        description: '<p>Zoberte si doklady.</p>'
      )
      create(:task, :external_link, step: step, title: 'Formulár matriky', url: 'https://example.test/form')
      create(:quick_tip, title: 'Praktický tip', slug: 'prakticky-tip', body: '<p>Nezabudnite na termíny.</p>', journey: journey, step: step)

      described_class.new(output_path: output_path, generated_at: generated_at).call

      content = File.read(output_path)

      expect(content).to include('<project title="Návody.Digital"')
      expect(content).to include('Vygenerované: 2026-03-28T10:00:00')
      expect(content).to include('url="http://localhost/kontakt"')
      expect(content).to include('FAQ: Ako to funguje?')
      expect(content).to include('Návod: Narodenie dieťaťa')
      expect(content).to include('Krok: Narodenie dieťaťa / Návšteva matriky')
      expect(content).to include('https://example.test/form')
      expect(content).to include('Rýchly tip: Praktický tip')
      expect(content).to include('Obsah &amp; detail')
      expect(content).not_to include('<p>')
    end
  end
end
