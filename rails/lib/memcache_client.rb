# -*- coding: utf-8 -*-
begin
  require 'memcached'
rescue LoadError
  require 'memcache'
end
#
# Class MemcacheClient provides Memcacheクライアント
#
# @author onishi
#
class MemcacheClient
  attr_accessor :connection

  DEFAULTS = {
    :no_block => false,
    :noreply => false,
    :buffer_requests => false,
    :cache_lookups => true,
    :support_cas => false,
    :tcp_nodelay => false,
    :show_backtraces => false,
    :retry_timeout => 30,
    :timeout => 0.25,
    :rcv_timeout => nil,
    :poll_timeout => nil,
    :connect_timeout => 4,
    :prefix_key => '',
    :prefix_delimiter => '',
    :hash_with_prefix_key => true,
    :default_ttl => 604800,
    :default_weight => 8,
    :sort_hosts => false,
    :auto_eject_hosts => true,
    :server_failure_limit => 2,
    :verify_key => true,
    :use_udp => false,
    :binary_protocol => false,
    :credentials => nil,
    :experimental_features => false,
    :exception_retry_limit => 5,
  }

  def initialize(*args)
    servers = []
    opts = {}

    case args.length
    when 0 then # NOP
    when 1 then
      arg = args.shift
      case arg
      when Hash then
        opts = arg
      when Array then
        servers = arg
      when String then
        servers = [arg]
      else
        raise ArgumentError, 'first argument must be Array, Hash or String'
      end
    when 2 then
      servers, opts = args
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
    end
    opts = DEFAULTS.merge(opts)
    if RUBY_PLATFORM == 'i386-mingw32' || !defined?(Memcached)
      # opts の互換性を保つ
      opts[:timeout] = nil if opts[:timeout] == 0
      # [:multithread]  Wraps cache access in a Mutex for thread safety.
      opts[:multithread] = opts.delete(:no_block) if opts[:no_block]
      opts[:no_reply] = opts.delete(:noreply) if opts[:noreply]
      opts[:namespace] = opts.delete(:prefix_key) if opts[:prefix_key]
      opts[:namespace_separator] = opts.delete(:prefix_delimiter) if opts[:prefix_delimiter]

      @connection = MemCache.new(servers, opts)
    else
      @connection = Memcached.new(servers, opts)
    end
  end

  module MemCacheMethods
    def set(key, value, ttl=604800, marshal=true)
      ttl = ttl.to_i if ttl.is_a?(Float) || ttl.is_a?(Time)
      return @connection.set(key, value, ttl, (!marshal))
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def get(keys, marshal=true)
      return nil if keys.nil?
      raw = (!marshal)

      return @connection.get_multi(keys, { :raw => raw }) if keys.is_a?(Array)
      return @connection.get(keys, raw)
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def delete(key, expiry=0)
      return @connection.delete(key, expiry)
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def decr(key, value=1)
      return @connection.decr(key, value)
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def server_by_key(key)
      return @connection.__send__(:get_server_for_key, key).inspect
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def reconnect!
      # no implementation
    end
  end

  module MemcachedMethods
    def set(key, value, ttl=604800, marshal=true, flags=0x0)
      ttl = ttl.to_i if ttl.is_a?(Float) || ttl.is_a?(Time)
      return @connection.set(key, value, ttl, marshal, flags)
    rescue => e
      # FIXME
      puts e.message
    end

    def get(keys, marshal=true)
      return nil if keys.nil?
      return @connection.get(keys, marshal)
    rescue Memcached::NotFound => nf
      # none
      nil
    end

    def delete(key, expiry=0)
      return @connection.delete(key)
    rescue Memcached::NotFound => nf
      # none
    rescue => e
      # FIXME
      puts e.message
      nil
    end

    def decr(key, value=1)
      return @connection.decr(key, value)
    rescue MemCache::MemCacheError => me
      # FIXME
      puts me.message
      nil
    end

    def server_by_key(key)
      return @connection.server_by_key(key)
    rescue Memcached::NotFound => nf
      # none
    rescue => e
      # FIXME
      puts e.message
      nil
    end

    def reconnect!
      # no implementation
    end
  end

  if RUBY_PLATFORM == 'i386-mingw32' || !defined?(Memcached)
    include MemCacheMethods
  else
    include MemcachedMethods
  end
end
