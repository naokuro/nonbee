class String
  #
  # 文字列が数字かどうか
  #
  def int?
    self == self.to_i.to_s
  end
end