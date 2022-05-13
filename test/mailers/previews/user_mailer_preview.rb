# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
# Preview all emails at https://39be319d407e4c7a909954bec3ccfe72.vfs.cloud9.us-east-1.amazonaws.com/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Preview this email at https://39be319d407e4c7a909954bec3ccfe72.vfs.cloud9.us-east-1.amazonaws.com/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
