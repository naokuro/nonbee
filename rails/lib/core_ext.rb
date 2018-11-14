class FalseClass;
  def to_i;
    0
  end
end

class TrueClass;
  def to_i;
    1
  end
end

class Object
  #
  # obj.tap { |o| ... } will be return origin +object+.
  # This is a method for checking whether chain methods is continuous or not. For example,
  #
  # A.new.tap { |o| o.create(...) if id }.save
  #
  # The function is totally the same as +Object::tap+, but this is optimize the return object,
  # let you use them smoothly.
  #
  # Also see Object::tap
  #
  # @param [Boolean] nilable check if nil is returnable or not.
  # @return [Object] +nil+ (Only {+nilable+} is true) or an +object+.
  #
  def tap_chain(nilable = false)
    res = yield self if block_given?

    nilable ? res : res || self
  end


  #
  # Just check the variable by +present?+ method.
  #
  # @param [Class] default if the variable is null, this parameter will be returned.
  # @return [Class|NilClass] return your default value.
  #
  def digself?(default = nil)
    self.present? ? self : default
  end

  #
  # Example
  # {a: {b: 13}}.dig_fetch(:a, :b) # 13
  # {a: nil}.dig_fetch(:a, :b) # nil
  #
  # @param [Array] variables the keys you wanna dig itself
  # @return [Any]
  #
  def dig_fetch(*variables)
    variables.reduce(self) { |s, i| s.try(:fetch, i.to_sym, nil) }
  end

end

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

class String
  #
  # 文字列が数字かどうか
  #
  def int?
    self == self.to_i.to_s
  end
end

class ActionDispatch::Request::Session
  #
  # Get the value from session then delete it.
  #
  # @param [String] key
  # @return [Object]
  #
  def obtain(key)
    val = @delegate[key.to_s]
    @delegate.delete(key.to_s) unless val.nil?
    val
  end
end

class Symbol
  #
  # symbol be underscore
  #
  def underscore
    self.to_s.underscore.to_sym
  end
end