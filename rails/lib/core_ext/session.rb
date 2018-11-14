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