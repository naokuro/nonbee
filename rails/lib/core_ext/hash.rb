class Hash
  #
  # Example, using it without a block,
  # {a: 12, b: 32}.fetch?(:a)         # 12
  # {a: 12, b: 32}.fetch?(:a, :b)     # [12, 32]
  # {a: 12, b: 32}.fetch?(:c)         # nil
  # {a: 12, b: 32}.fetch?(:a, :b, :c) # nil
  #
  # with a block
  # {a: 12, b: 32}.fetch?(:a) { |res| res.to_s }        # "12"
  # {a: 12, b: 32}.fetch?(:a, :b) { |res| res[1].to_s } # "32"
  # {a: 12, b: 32}.fetch?(:a, :c) { |res| res.to_s }    # nil
  #
  # @param [Array] variables the keys you wanna fetch.
  # @return [Array|Object] if using the +block+, the return value will be the operation of the block end line;
  #                        otherwise, it will directly return the check result.
  #
  def fetch?(*variables)
    values, is_exist_list = variables.map { |v| [self.dig(v), !self.dig(v).nil?] }.transpose

    is_exist_list.all? ? (1 == values.size ? values.first : values).tap { |ret| return yield ret if block_given? } : nil
  end
end
