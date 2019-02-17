module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def searchable(search_by, search_for)
      @searchable_by = search_by
      @searchable_for = search_for

      def self.searchable_by
        @searchable_by
      end

      def self.searchable_for
        @searchable_for
      end
    end
  end

  included do
    before_save :generate_search_terms

    scope :search, -> (query) {
      query = Transliterator.transliterate(query).gsub(/\s+/, ' ').gsub(' ', ' | ')

      where("#{table_name}.#{searchable_by} @@ to_tsquery(?)", query)
        .select("*", sanitize_sql_array(["ts_rank_cd(to_tsvector(#{table_name}.#{searchable_by}), to_tsquery(?), 1) AS rank", query]))
        .reorder('rank DESC')
    }
  end

  def generate_search_terms
    res = self.class.searchable_for.map do |attr|
      Transliterator.transliterate(public_send(attr)&.downcase)
    end
    public_send("#{self.class.searchable_by}=", res.join(' ').strip)
  end
end
