# == Schema Information
#
# Table name: code_list.countries
#
#  id                 :integer          not null, primary key
#  identifier         :integer
#  value              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CodeList::Country < ApplicationRecord
  self.table_name = "code_list.countries"
end
