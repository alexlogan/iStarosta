class Lesson < ActiveRecord::Base
  has_many :logs, dependent: :delete_all
  has_one :absence, dependent: :delete
  validates :name,
            presence:true,
            uniqueness: true,
            format: {
              with: /\A[а-яА-Я0-9.\s]+/,
              message: "only allows letters, numbers and \".\""
            }
end
