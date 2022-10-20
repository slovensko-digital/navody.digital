# == Schema Information
#
# Table name: code_list.courts
#
#  id                 :integer          not null, primary key
#  name               :string
#  identifier         :integer
#  code               :string
#  street             :string
#  number             :string
#  postal_code        :integer
#  municipality       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CodeList::Court < ApplicationRecord
  self.table_name = "code_list.courts"
end
