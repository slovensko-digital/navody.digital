require 'rails_helper'

RSpec.describe Legal::SlovLexLink do

  let(:url_minimum) {
    "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530"
  }

  let(:url_with_section) {
    "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530#paragraf-7.odsek-19"
  }

  let(:url_with_date) {
    "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/20211201.html"
  }

  let(:url_with_date_and_section) {
    "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/20211201.html#paragraf-7.odsek-19"
  }

  describe "#current_date_version" do
    it "no section" do
      urls = [url_minimum, url_with_section, url_with_date, url_with_date_and_section]
      urls.each do |url|
        link = Legal::SlovLexLink.new(url)
        expect(link.current_date_version).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/")
      end
    end

    it "with section 1" do
      link = Legal::SlovLexLink.new(url_minimum)
      expect(
        link.current_date_version(with_section: true)
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/")
    end

    it "with section 2" do
      link = Legal::SlovLexLink.new(url_with_section)
      expect(
        link.current_date_version(with_section: true)
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/#paragraf-7.odsek-19")
    end

    it "with section 3" do
      link = Legal::SlovLexLink.new(url_with_date)
      expect(
        link.current_date_version(with_section: true)
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/")
    end

    it "with section 4" do
      link = Legal::SlovLexLink.new(url_with_date_and_section)
      expect(
        link.current_date_version(with_section: true)
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/#paragraf-7.odsek-19")
    end
  end

  describe "#date_version" do
    it "add given date to url #1" do
      url = "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/20211201.html#paragraf-7.odsek-19"

      link = Legal::SlovLexLink.new(url)
      expect(
        link.date_version(date_string: "19981202")
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/19981202.html")

      link = Legal::SlovLexLink.new(url)
      expect(
        link.date_version(date_string: "19981202", with_section: true)
      ).to eq("https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2003/530/19981202.html#paragraf-7.odsek-19")
    end
  end

end
