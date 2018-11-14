class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :tap_del, -> (del_flg = 1, with_flg = true) { where({ del_flg: del_flg }) if with_flg }

  module TModule
    #
    # Retrieving the data by id.
    #
    # @param [Integer] id id.
    # @param [Integer] del_flag delete flag. It allows to input +nil+ or +false+ or +Integer+ 0 or 1.
    #
    # @return [Object] a +database_object+ information or +nil+.
    #
    # OPTIMIZE(jieyi): 9/8/17 The order of `del_flag` & `with_flg` doesn't make sense well. It's a little wired.
    def get_by_id(id, del_flag = 0, with_flg = true)
      self.where({ id: id }).
          tap_del(del_flag, with_flg).
          # HACK(jieyi): 7/25/17 Here is kind of wried. The return value should be one data type.
          tap_chain(true) { |o|
            id.is_a?(Array) ? o : o.take }
    end

    #
    # Retrieving the data by t_user_id.
    #
    # @param [Integer] t_user_id member id.
    # @param [Integer] del_flag delete flag. It allows to input +nil+ or +false+ or +Integer+ 0 or 1.
    #
    # @return [Object] a +database_object+ information.
    #
    # OPTIMIZE(jieyi): 9/8/17 The order of `del_flag` & `with_flg` doesn't make sense well. It's a little wired.
    def get_by_t_user_id(t_user_id, del_flag = 0, with_flg = true)
      self.where({ t_user_id: t_user_id }).
          tap_del(del_flag, with_flg).
          # HACK(jieyi): 7/25/17 Here is kind of wried. The return value should be one data type.
          tap_chain(true) { |o| t_user_id.is_a?(Array) ? o : o.take }
    end

    #
    # 存在しなければINSERT 存在すればUPDATE
    #
    # @param [Integer] t_user_id 会員ID
    # @param [Hash] params インサート/アップデート パラメータ
    # @return [Object] 更新後のオブジェクト
    #
    def upsert_by_t_user_id(t_user_id, params)
      (self.get_by_t_user_id(t_user_id) || self.new).tap { |it|
        params[:t_user_id] = t_user_id
        params.each { |k, v| eval("it.#{k} = v if defined?(it.#{k})") }
        it.save!
      }
    end
  end
end
