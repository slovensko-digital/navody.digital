# == Schema Information
#
# Table name: upvs.form_template_related_documents
#
#  id                   :integer          not null, primary key
#  posp_id              :string           not null
#  posp_version         :string           not null
#  message_type         :string           not null
#  xsd_schema           :text
#  xslt_transformation  :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Upvs::FormTemplateRelatedDocument < ApplicationRecord
  self.table_name = "upvs.form_template_related_documents"
end
