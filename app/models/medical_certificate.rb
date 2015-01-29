class MedicalCertificate < ActiveRecord::Base
  belongs_to :student
  validates :from, presence: true
  validates :till, presence: true
end
