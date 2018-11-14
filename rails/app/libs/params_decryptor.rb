module ParamsDecryptor

  #
  # リクエストパラメータをデコードしてJsonの形にする
  #
  # @param [String]  param   エンコードされているパラメータ
  # @param [Encrypt] encrypt 暗号化module
  #
  # @return [String] Json
  #
  def parse_encoded_parameter(param, encrypt)
    encrypt.decode(URI.decode(param))
  end
end