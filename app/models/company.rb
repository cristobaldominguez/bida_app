# == Schema Information
#
# Table name: companies
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE)
#  name          :string
#  taxid         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bf_contact_id :bigint
#  contact_id    :bigint
#  industry_id   :bigint
#
# Indexes
#
#  index_companies_on_bf_contact_id  (bf_contact_id)
#  index_companies_on_contact_id     (contact_id)
#  index_companies_on_industry_id    (industry_id)
#
# Foreign Keys
#
#  fk_rails_...  (industry_id => industries.id)

class Company < ApplicationRecord
  has_many :plants, dependent: :destroy
  belongs_to :industry

  belongs_to :contact, class_name: 'User'
  belongs_to :bf_contact, class_name: 'User'

  validates :name, presence: true, uniqueness: true
end
