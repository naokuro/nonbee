#
# Class Api::V1::ApplicationController provides
#
# @author onishi
#
class Api::V1::ApplicationController < ActionController::API
  include Error
  include Encrypt
  include ParamsDecryptor
  include Dispatcher

  attr_accessor :error_messenger, :path
  before_action :set_error_messenger

  rescue_from Exception do |e|
    render 'api/common/error', formats: [:json], handlers: [:jbuilder], locals: { err_code: Error::SYM_TO_CODE[:internal_server_error], msg: e.message,
                                                                                  msg_code: (get_code_prefix << Error::SYM_TO_CODE[:internal_server_error].to_s << '01').to_i }
  end

  # FIXME: 何かCustomErrorがエラーになって読み込めない
  rescue_from CustomError do |e|
    e.msg_code(@error_messenger) if e.message_code == 0
    render 'api/common/error', formats: [:json], handlers: [:jbuilder], locals: { err_code: e.code, msg: e.message, msg_code: e.message_code }
  end

  #
  # パラメータが足りるかチェックしてerror_checkの形のHashを行う
  #
  # @param [Array] necessary_params 必要パラメータ
  # @param [String] msg エラーメッセージ
  # @return [Hash] error_checkで必要な形
  #
  def enough_params_statement?(necessary_params, msg = 'Your parameters are not enough.')
    { proc { !necessary_params.all? } => error_message(:bad_request, msg) }
  end

  #
  # Running error check for all checking.
  #
  # @param [Hash<Proc, List|CustomError>] error_statement
  #
  def error_check(error_statement)
    error_happen = error_statement.find { |condition, _| condition.call }&.fetch(1) # index 1 is error msg.
    raise error_happen if error_happen.is_a?(CustomError)
    raise CustomError.new(*error_happen) if error_happen
  end

  #
  # パラメータをデコードする
  #
  # @param [String] token トークン
  # @param [Encrypt] encrypt 暗号化module
  #
  def decrypt_parameter(token, encrypt)
    parse_json(parse_encoded_parameter(token, encrypt)).each { |k, v|
      params[k.underscore] = v
    }
  end

  #
  # jsonをパースする
  #
  # @param  [String] json_str 文字列のJson
  # @return [Hash] Hash化後Json
  #
  def parse_json(json_str)
    JSON.parse(json_str, { symbolize_names: true })
  end

  #
  # URL属するエラーコードを取得する
  #
  def set_error_messenger
    @error_messenger = ErrorMessage.new(get_code_prefix)
  end

  #
  # エラーメッセージ取得
  #
  # @param [Symbol] code エラーシンボル
  # @param [String] msg エラーメッセージ
  # @return [ErrorObject]
  #
  def error_message(code, msg = nil)
    err = ErrorFactory.create(code).msg_code(@error_messenger)
    err.msg(msg) unless msg.nil?
  end
end
