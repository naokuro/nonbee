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
