# == Schema Information
#
# Table name: code_list.municipalities
#
#  id                 :integer          not null, primary key
#  identifier         :integer
#  value              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CodeList::Municipality < ApplicationRecord
  self.table_name = "code_list.municipalities"
end
