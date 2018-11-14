require 'error/error'

class ErrorFactory
  include Error
  include Error::ApiError

  ERROR_CATEGORY = { bad_request: BadRequestError,
                     unauthorized: UnauthorizedError,
                     forbidden: ForbiddenError,
                     not_found: NotFoundError }

  #
  # Create a error exception. see Error::ApiError.
  #
  # @param [Symbol|List] mixin It can be a +symbol+ for creating a exist error class or
  #                            put a list [Int, String] for creating a custom error class.
  # NOTE: For the custom error class, you have to do like [Error::SYM_TO_CODE[:bad_request], 'MESSAGE'].
  # @return [Object] a +CustomError+'s subclass.
  #
  def self.create(mixin)
    if mixin.is_a?(Symbol) && ERROR_CATEGORY.include?(mixin)
      ERROR_CATEGORY[mixin].new
    else
      raise Exception("The parameter isn't fitting the rule, it should be [Int, String]") if mixin.length != 2 || !(mixin[0].is_a?(Integer) || mixin[1].is_a?(String))
      CustomError.new(mixin[0], mixin[1])
    end
  end
end