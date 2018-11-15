#
# Class TUser provides 会員モデル
#
# @author onishi
#
class TUser < ApplicationRecord
  extend ApplicationRecord::TModule

  # 暗号化
  attr_encrypted :email, key: Rails.application.credentials.key, algorithm: 'aes-256-gcm', mode: :single_iv_and_salt, insecure_mode: true
  attr_encrypted :password, key: Rails.application.credentials.key, algorithm: 'aes-256-gcm', mode: :single_iv_and_salt, insecure_mode: true

  # validate
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: 'を正しく入力してください' }
  validates :password, presence: true, length: { minimum: 8, too_short: 'は8文字以上入力してください' }, if: proc { self.password.present? }, unless: proc { [:sign_in].include?(validation_context) }, format: { with: VALID_PASSWORD_REGEX }

  # validate :validate_exist_email?, on: :sign_in
  # validate :validate_password?, on: :sign_in

  #
  # 初期化
  #
  # @param [Hash] params パラメータ
  # @return [Objecgt]
  #
  def init(params)
    self.email    = params[:email]
    self.password = params[:password]
    self.nickname = ''
    self
  end
  # Emailで会員情報を取得する
  # @param [String]  email
  # @return [Object]
  def self.get_by_email(email)
    email = self.encrypt_email(email)
    self.find_by({encrypted_email: email, del_flg: 0})
  end

=begin
  # validate
  #
  # 生年月日チェック
  #
  # @return [Object]
  #
  def validate_exist_email?
    return errors.add(:email, 'は登録されていません') unless self.exists?(email: email)
  end

  def validate_password?

  end
=end

end
