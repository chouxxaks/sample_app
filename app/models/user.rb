class User < ApplicationRecord
  before_save { email.downcase! }
  validates(:name,  presence: true, length: {maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i   # (英数字_+-.のいずれかを１文字以上 @ 英子文字数字-.のいずれかを１文字以上 . 英子文字) 大文字小文字は無視
  validates(:email, presence: true, 
                    length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
            )
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
