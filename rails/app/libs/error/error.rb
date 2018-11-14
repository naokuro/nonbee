module Error
  # See http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/.
  SYM_TO_CODE = Rack::Utils::SYMBOL_TO_STATUS_CODE

  class CustomError < Exception
    attr_reader :code
    attr_accessor :message, :message_code

    #
    # Initialize.
    #
    # @param [Integer] code error code.
    # @param [String] message error message.
    #
    def initialize(code = nil, message = nil)
      @code = code || SYM_TO_CODE[:internal_server_error]
      @message = message || 'Something went wrong!!'
      @message_code = 0
    end

    #
    # Set the msg and it can chain methods.
    #
    # @param [String] message error message.
    # @return [Error] self.
    #
    def msg(message = nil)
      @message = message
      self
    end

    def msg_code(error_messenger)
      @message_code = error_messenger.get_error_message_code(@code)
      self
    end
  end
end

module Error
  module ApiError
    class BadRequestError < CustomError
      #
      # Initialize.
      #
      # @param [String] message error message.
      #
      def initialize(message = nil)
        super(SYM_TO_CODE[:bad_request], message || 'Your parameters is incorrect.')
      end
    end

    class UnauthorizedError < CustomError
      #
      # Initialize.
      #
      # @param [String] message error message.
      #
      def initialize(message = nil)
        super(SYM_TO_CODE[:unauthorized], message)
      end
    end

    class ForbiddenError < CustomError
      #
      # Initialize.
      #
      # @param [String] message error message.
      #
      def initialize(message = nil)
        super(SYM_TO_CODE[:forbidden], message)
      end
    end

    class NotFoundError < CustomError
      #
      # Initialize.
      #
      # @param [String] message error message.
      #
      def initialize(message = nil)
        super(SYM_TO_CODE[:not_found], message || 'Not found resource.')
      end
    end
  end
end