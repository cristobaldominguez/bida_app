class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :confirmable

  validates :name, :lastname, :email, presence: true

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy

  has_and_belongs_to_many :plants
  has_and_belongs_to_many :inspections
  has_and_belongs_to_many :supports
  has_and_belongs_to_many :alerts

  has_many :contact_companies, class_name: 'Company', foreign_key: 'contact_id'
  has_many :bf_contact_companies, class_name: 'Company', foreign_key: 'bf_contact_id'

  has_many :on_site_user_inspections, class_name: 'Inspection', foreign_key: 'on_site_user_id'
  has_many :report_technician_inspections, class_name: 'Inspection', foreign_key: 'report_technician_id'

  has_many :logbook_bf_responsible_plants, class_name: 'Plant', foreign_key: 'logbook_bf_responsible_id'
  has_many :logbook_bf_supervisor_plants, class_name: 'Plant', foreign_key: 'logbook_bf_supervisor_id'
  has_many :logbook_company_responsible_plants, class_name: 'Plant', foreign_key: 'logbook_company_responsible_id'

  has_many :contact_plants, class_name: 'Plant', foreign_key: 'contact_id'
  has_many :bf_contact_plants, class_name: 'Plant', foreign_key: 'bf_contact_id'

  has_many :client_supports, class_name: 'Support', foreign_key: 'client_id'
  has_many :bf_technician_supports, class_name: 'Support', foreign_key: 'bf_technician_id'

  enum interface_color: %i[light dark]
  enum employee: %i[company biofiltro]
  enum role: %i[no_role admin client operator operations_manager viewer]

  def full_name
    "#{name} #{lastname}"
  end

  def self.filtered_by(filter)
    filter.users.where.not(filtered: true)
  end

  def self.filtered
    where.not(filtered: true)
  end
end
