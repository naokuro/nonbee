# -*- coding: utf-8 -*-
require 'digest/sha1'
require 'db_cache'

module ActsAsCached
  def self.included(base)
    base.extend(RecordCache)
    # if base.superclass == ActiveRecord::Base
    #   base.extend(ActiveRecord::ActsAsCached::BasicMethods)
    # end
    base.extend(ActiveRecord::ActsAsCached::BasicMethods) if base.superclass == ApplicationRecord
  end

  module RecordCache
    def get_cache(key = nil, ttl = 0, &block)
      return nil if key.nil?
      dkey = digest_key(key)
      if (rs = autoload_missing_constants { DBCache.get(dkey) })
        return rs
      end
      if block_given?
        if (rs = yield)
          DBCache.set(dkey, rs, ttl)
          return rs
        end
      end

      nil
    end

    def autoload_missing_constants
      yield
    rescue ArgumentError => error
      lazy_load ||= Hash.new { |hash, hash_key| hash[hash_key] = true; false }
      if error.to_s[/undefined class|referred/] && !lazy_load[error.to_s.split.last.sub(/::$/, '').constantize]
        retry
      else
        raise error
      end
    end

    def multiget_cache(keys)
      dkeys = keys.map { |k| digest_key(k) }

      DBCache.get(dkeys)
    end

    # multiget_cacheは戻り値がdkeyになる
    # keyを維持する必要がある場合はこちらを利用
    # block未対応
    def multiget_cache_with_key(keys)
      dkey_key_map = keys.inject({}) { |h, k| h[digest_key(k)] = k; h }
      rs = DBCache.get(dkey_key_map.keys)
      return nil if rs.nil?
      rs.inject({}) { |h, (dk, v)| h[dkey_key_map[dk]] = v; h }
    end

    def set_cache(key, rs, ttl=0)
      DBCache.set(digest_key(key), rs, ttl)
    end

    def expire_cache(key)
      DBCache.delete(digest_key(key))
    end

    def digest_key(key)
      key = case key
            when Array
              key.flatten.join('-')
            else
              key.to_s unless key.is_a?(String)
            end

      Digest::SHA1.hexdigest("#{cache_name}:#{key}")
    end

    def cache_name
      self.name
    end

    def cache_key(*args)
      args.flatten.join('_')
    end
  end
end
