#
# Class TUser provides 会員モデル
#
# @author onishi
#
class TUser < ApplicationRecord
  extend ApplicationRecord::TModule

  # 暗号化
  attr_encrypted :email, key: Rails.application.credentials.key, insecure_mode: true, algorithm: 'aes-256-cbc', mode: :single_iv_and_salt
  attr_encrypted :password, key: Rails.application.credentials.key, insecure_mode: true, algorithm: 'aes-256-cbc', mode: :single_iv_and_salt

end
