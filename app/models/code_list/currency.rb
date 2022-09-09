# == Schema Information
#
# Table name: code_list.currencies
#
#  id                 :integer          not null, primary key
#  identifier         :integer
#  value              :string
#  code               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CodeList::Currency < ApplicationRecord
  self.table_name = "code_list.currencies"
end
