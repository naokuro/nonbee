module Dispatcher
  ERROR_PREFIX = [
    {
      code: '0101',
      request: 'GET',
      path: '/member/info'
    },
    {
      code: '0102',
      request: 'GET',
      path: '/member/email'
    },
    {
      code: '0103',
      request: 'GET',
      path: '/member/point'
    },
    {
      code: '0104',
      request: 'POST',
      path: '/member/watch_request'
    },
    {
      code: '0105',
      request: 'GET',
      path: '/member/favorite'
    },
    {
      code: '0106',
      request: 'POST',
      path: '/member/add_favorite'
    },
    {
      code: '0107',
      request: 'DELETE',
      path: '/member/remove_favorite'
    },
    {
      code: '0108',
      request: 'GET',
      path: '/member/invitation_code'
    },
    {
      code: '0109',
      request: 'GET',
      path: '/member/store_reserved_item'
    },
    {
      code: '0110',
      request: 'POST',
      path: '/member/campaign'
    },
    {
      code: '0111',
      request: 'PUT',
      path: '/member/use_coupon'
    },
    {
      code: '0112',
      request: 'PUT',
      path: '/member/change_password'
    },
    {
      code: '0113',
      request: 'POST',
      path: '/member/change_password_verify'
    },
    {
      code: '0114',
      request: 'PUT',
      path: '/member/change_email'
    },
    {
      code: '0115',
      request: 'POST',
      path: '/member/change_email_verify'
    },
    {
      code: '0116',
      request: 'PUT',
      path: '/member/change_address'
    },
    {
      code: '0117',
      request: 'POST',
      path: '/member/change_address_verify'
    },
    {
      code: '0118',
      request: 'PUT',
      path: '/member/change_basic_info'
    },
    {
      code: '0119',
      request: 'PUT',
      path: '/member/change_wrist'
    },
    {
      code: '0120',
      request: 'PUT',
      path: '/member/change_credit_card'
    },
    {
      code: '0121',
      request: 'POST',
      path: '/member/suspend'
    },
    {
      code: '0122',
      request: 'POST',
      path: '/member/withdrawal'
    },
    {
      code: '0123',
      request: 'POST',
      path: '/member/withdrawal_verify'
    },
    {
      code: '0201',
      request: 'GET',
      path: '/item/list'
    },
    {
      code: '0202',
      request: 'GET',
      path: '/item/detail'
    },
    {
      code: '0203',
      request: 'GET',
      path: '/item/brand_list'
    },
    {
      code: '0301',
      request: 'POST',
      path: '/register/pre_register'
    },
    {
      code: '0302',
      request: 'POST',
      path: '/register/pre_verify'
    },
    {
      code: '0303',
      request: 'POST',
      path: '/register/basic_info'
    },
    {
      code: '0304',
      request: 'POST',
      path: '/register/register'
    },
    {
      code: '0401',
      request: 'POST',
      path: '/authority/login'
    },
    {
      code: '0402',
      request: 'POST',
      path: '/authority/logout'
    },
    {
      code: '0403',
      request: 'POST',
      path: '/authority/rescue_password'
    },
    {
      code: '0501',
      request: 'GET',
      path: '/information/list'
    },
    {
      code: '0502',
      request: 'GET',
      path: '/information/detail'
    },
    {
      code: '0601',
      request: 'GET',
      path: '/feature/list'
    },
    {
      code: '0602',
      request: 'GET',
      path: '/item/feature_items'
    },
    {
      code: '0701',
      request: 'GET',
      path: '/member/rentable'
    },
    {
      code: '0702',
      request: 'GET',
      path: '/member/renting_item'
    },
    {
      code: '0703',
      request: 'GET',
      path: '/member/reserving_item'
    },
    {
      code: '0704',
      request: 'GET',
      path: '/member/rent_history'
    },
    {
      code: '0705',
      request: 'POST',
      path: '/member/into_cart'
    },
    {
      code: '0706',
      request: 'POST',
      path: '/member/rent'
    },
    {
      code: '0801',
      request: 'GET',
      path: '/item/priority_reserve_item'
    },
    {
      code: '0802',
      request: 'GET',
      path: '/item/priority_search_items'
    },
    {
      code: '0803',
      request: 'GET',
      path: '/item/similar'
    },
    {
      code: '0804',
      request: 'GET',
      path: '/member/priority_reserve'
    },
    {
      code: '0805',
      request: 'POST',
      path: '/member/set_priority_reserve'
    },
    {
      code: '0806',
      request: 'POST',
      path: '/member/remove_priority_reserve'
    },
    {
      code: '0807',
      request: 'POST',
      path: '/member/cancel_priority_reserve'
    },
    {
      code: '0901',
      request: 'POST',
      path: '/inquiry/to_inquire'
    },
    {
      code: '1001',
      request: 'GET',
      path: '/paygent/validate'
    },
    {
      code: '1002',
      request: 'GET',
      path: '/paygent/card_info'
    },
    {
      code: '1101',
      request: 'GET',
      path: '/authority/validate_token'
    }
  ]

  UNKNOWN_PATH_ERR = '9999'

  #
  # URLパスまでのエラーコードを取得する
  #
  # ex) '0101' #/member/info
  #
  # @return [String] エラーコードの一部
  #
  def get_code_prefix
    path = '/' << params['controller'].split('/').last << '/' << params['action']
    ERROR_PREFIX.select { |it| it[:path] == path && request.request_method == it[:request] }.first&.fetch(:code) || UNKNOWN_PATH_ERR
  end
end

class ErrorMessage
  include Dispatcher

  attr_accessor :number, :code_prefix

  #
  # 初期化
  #
  # @param [String] code_prefix メッセージコードの先頭4文字(ex: 0101, 0102...)
  #
  def initialize(code_prefix)
    @number = {
      400 => 0,
      401 => 0,
      404 => 0,
      500 => 0
    }
    @code_prefix = code_prefix
  end

  #
  # 完成したメッセージコードを取得
  #
  # @param [Integer] error_code エラーコード(ex: 400, 404...)
  # @return [Integer] メッセージコード(ex: 10140001, 1014002, 10140101...)
  #
  def get_error_message_code(error_code)
    (@code_prefix.clone << error_code.to_s << sprintf('%02d', @number[error_code] += 1)).to_i
  end
end