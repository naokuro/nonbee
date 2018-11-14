class Symbol
  #
  # symbol be underscore
  #
  def underscore
    self.to_s.underscore.to_sym
  end
end