# -*- coding: utf-8 -*-
#
# Class DBCache provides データベースキャッスクラス
#
# @author onishi
#
require 'memcache_client'
require 'singleton'
class DBCache
  include Singleton

  attr_accessor :connection

  def load_config
    self.connection = MemcacheClient.new(Consts.env('db_cache_host_with_port'), {
      :timeout => Consts.env('db_cache_timeout'),
      :prefix_key => Rails.env,
      :prefix_delimiter => Consts.env('db_cache_prefix_delimiter'),
    })
  end

  module DummyClassMethods
    def set(k, v, ttl=0, marshal=true)
    end

    def get(k, marshal=true)
    end

    def delete(k)
    end

    def decr(k, v)
    end

    def server_by_key(key)
    end

    def reconnect!
      # no implementation
    end
  end

  module ClassMethods
    def set(k, v, ttl=0, marshal=true)
      # key, value, ttl=604800, marshal=true
      self.connection.set(k, v, ttl, marshal)
    end

    def get(k, marshal=true, &block)
      # keys, marshal=true
      result = autoload_missing_constants { self.connection.get(k, marshal) }
      if block_given? && result.nil?
        result = block.call
        set(k, result, 0, marshal)
      end
      result
    end

    def delete(k)
      self.connection.delete(k)
    end

    def decr(k, v)
      self.connection.decr(k, v)
    end

    def reconnect!
      # no implementation
    end

    def autoload_missing_constants
      begin
        yield
      rescue ArgumentError => error
        lazy_load ||= Hash.new { |hash, hash_key| hash[hash_key] = true; false }
        if error.to_s[/undefined class|referred/] && !lazy_load[error.to_s.split.last.sub(/::$/, '').constantize]
          retry
        else
          raise error
        end
      end
    end
  end

  def self.connection
    self.instance.load_config if self.instance.connection.nil?

    self.instance.connection
  end

  def self.enabled
    return Consts.env('db_cache_enabled')
  end

  if !DBCache.enabled || Rails.env == 'test'
    extend DummyClassMethods
  else
    extend ClassMethods
  end
end

