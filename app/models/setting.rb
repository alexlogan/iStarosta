class Setting < ActiveRecord::Base
  belongs_to :group
  validates :current_semester, numericality: {
                       only_integer: true,
                       greater_than_or_equal_to:  1,
                       less_than_or_equal_to: 12
                     }
  validates :current_block, numericality: {
                   only_integer: true,
                   greater_than_or_equal_to:  1,
                   less_than_or_equal_to: 2
                 }

  after_update :update_logs,
               if: Proc.new{ threshold_date_changed? }

  private
  def update_logs
    semester_logs = group.logs.where(lessons: {semester: group.setting.current_semester})
    semester_logs.each do |log|
      if log.date < threshold_date
        log.block = 1
        log.save
      else log.date >= threshold_date
        log.block = 2
        log.save
      end
    end
  end

end
