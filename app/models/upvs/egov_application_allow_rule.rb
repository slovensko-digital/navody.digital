# == Schema Information
#
# Table name: egov_application_rules
#
#  id                 :integer          not null, primary key
#  recipient_uri      :string           not null
#  posp_id            :string           not null
#  posp_version       :string           not null
#  message_type       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_upvs.egov_application_rules_on_recipient_uri    (recipient_uri)
#

class Upvs::EgovApplicationAllowRule < ApplicationRecord
end
