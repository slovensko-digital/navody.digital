# == Schema Information
#
# Table name: or_sr_company_records
#
#  id                                          :integer          not null, primary key
#  cin                                         :bigint           not null
#  identifiers_ok                              :boolean          not null, default false
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null

module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class CompanyRecord < ApplicationRecord
        self.table_name = "or_sr_company_records"
      end
    end
  end
end
