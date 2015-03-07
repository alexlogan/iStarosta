class MedicalCertificate < ActiveRecord::Base
  belongs_to :student
  validates :from, presence: true
  validates :till, presence: true

  before_create :set_semester

  private
  def set_semester
    self.semester = self.student.group.setting.current_semester
  end
end
