module Encrypt
  #
  # Encode a string.
  #
  # @param [String] str a string will be encode.
  # @return [String] an encoded string.
  #
  def encode(str)
    raise 'You have to implement this method!'
  end

  #
  # Decode a string which encode by this model.
  #
  # @param [String] encrypted_str an encrypted string by this model.
  # @return [String] an original string.
  #
  def decode(encrypted_str)
    raise 'You have to implement this method!'
  end
end


class DoubleEncrypt
  include Encrypt

  #
  # Encode a string.
  #
  # @param [String] str a string will be encode.
  # @return [String] an encoded string.
  #
  def encode(str)
    # @type [String]
    first_encrypted_str = first_level_encrypt(str)
    # @type [String]
    key = first_encrypted_str.
      chars.
      tap_chain { |it| [it[2], it[it.size / 2], it[it.size - 1]] }.
      map(&:ord).
      inject { |acc, c| acc ^ c }.
      chr
    # @type [String]
    double_encrypted_str = first_encrypted_str.bytes.map { |it| (it ^ key.ord).chr }.join

    append_key(double_encrypted_str, str)
  end

  #
  # Decode a string which encode by this model.
  #
  # @param [String] encrypted_str an encrypted string by this model.
  # @return [String] an original string.
  #
  def decode(encrypted_str)
    # @type [String]
    key = extract_key(encrypted_str)
    # @type [String]
    decode = encrypted_str.bytes.map { |it| (it ^ key.ord).chr }.join

    first_level_encrypt(remove_redundant_key(decode))
  end

  # region Protected Methods

  #
  # Appending the decrypt's key into the encrypt string for hiding the and mix the encrypted string.
  #
  # @param [String] encrypted_str the string which encrypted.
  # @param [String] original_str the string has operated first encrypt.
  # @return [String] mixed encrypted string with the decrypt keys.
  #
  def append_key(encrypted_str, original_str)
    encrypted_str.chars.tap { |it|
      it.insert(2, original_str[2])
      it.insert(it.size / 2, original_str[original_str.size / 2])
      it.insert(it.size - 1, original_str[-1])
    }.join
  end

  #
  # Extract a key from the mixed encrypted string.
  #
  # @param [String] encrypted_str the string which encrypted.
  # @return [String] a key which extracted from a mixed string.
  #
  def extract_key(encrypted_str)
    encrypted_str.chars.tap_chain { |it|
      last = it.delete_at(it.size - 2)
      mid = it.delete_at((it.size - 1) / 2)
      first = it.delete_at(2)

      [first, mid, last].map(&:ord).inject { |acc, c| acc ^ c }.chr
    }
  end

  #
  # Remove the redundant keys from a mixed first encrypted string, to be a original first encrypted string.
  # @param [String] encrypted_str the string which encrypted with the decrypt keys.
  # @return [String] a string which has operated the first encrypt.
  #
  def remove_redundant_key(encrypted_str)
    encrypted_str.chars.tap { |it|
      it.delete_at(it.size - 2)
      it.delete_at((it.size - 1) / 2)
      it.delete_at(2)
    }.join
  end

  # TODO(jieyi): 2018/02/28 Add a first common well-known encrypt method.
  def first_level_encrypt(str)
    str
  end

  def first_level_decrypt(str)
    str
  end

  # endregion

  protected :append_key, :extract_key, :remove_redundant_key, :first_level_encrypt, :first_level_decrypt
end