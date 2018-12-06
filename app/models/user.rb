class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy

  has_and_belongs_to_many :plants

  has_many :contact_companies, class_name: 'Company', foreign_key: 'contact_id'
  has_many :bf_contact_companies, class_name: 'Company', foreign_key: 'bf_contact_id'

  has_many :contact_plants, class_name: 'Plant', foreign_key: 'contact_id'
  has_many :bf_contact_plants, class_name: 'Plant', foreign_key: 'bf_contact_id'

  def full_name
    "#{name} #{lastname}"
  end
end
