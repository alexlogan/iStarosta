class User < ActiveRecord::Base
  has_one :group, :autosave => true
  has_many :students, :through => :group
  has_many :lessons, :through => :group
  accepts_nested_attributes_for :group

  validates :name, presence: true,
            format: {
              with: /\A[а-яА-Яa-zA-Z\s]+\z/,
              message: "only allows letters"
            }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %i[admin]
  # arr.reject {|e| e == 5}

  def with_group
    build_group if group.nil?
    self
  end

end
