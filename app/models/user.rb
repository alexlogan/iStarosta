class User < ActiveRecord::Base
  has_one :group
  has_many :students, :through => :group
  has_many :lessons, :through => :group
  accepts_nested_attributes_for :group

  validates :name, presence: true,
            format: {
              with: /\A[а-яА-Яa-zA-Z\s]+/,
              message: "only allows letters"
            }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def with_group
    build_group if group.nil?
    self
  end

end
