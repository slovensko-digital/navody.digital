module Datahub
  module Socpoist
    class Debtor < DatahubRecord
      self.table_name = "socpoist.debtors"

      attribute :search_score, :float, default: nil

      def self.search(name, threshold = 0.5)
        table = self.arel_table
        similarity_condition = lambda do
          Arel::Nodes::NamedFunction.new("similarity",
            [
              Arel::Nodes::NamedFunction.new("unaccent", [
                table[:name],
              ]),
              Arel::Nodes::NamedFunction.new("unaccent", [
                Arel::Nodes.build_quoted(name)
              ])
            ]
          )
        end

        select(similarity_condition.call.as("search_score"), table[Arel.star])
          .where(similarity_condition.call.gt(threshold))
          .order(search_score: :desc)
          .limit(10)
      end
    end
  end
end
