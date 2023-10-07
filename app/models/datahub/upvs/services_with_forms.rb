module Datahub
  module Upvs
    class ServicesWithForms < DatahubRecord
      def self.search(query)
        select('DISTINCT ON (institution_name) *').where('unaccent(institution_name) ilike unaccent(?)', "%#{query}%")
          .is_valid.order(:institution_name).limit(15).pluck(:institution_name)
      end

      def self.is_valid
        # is it localized ? or PG time is ok
        where('(valid_from < Now() OR valid_from IS NULL) AND (valid_to > Now() OR valid_to IS NULL) ')
      end
    end
  end
end

