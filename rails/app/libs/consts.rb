# -*- coding: utf-8 -*-
require 'singleton'
require 'yaml'

# Consts.config(key) でアクセス可能
# Consts.env(key) でアクセス可能
class Consts
  include Singleton

  APP_CONFIG_YML_PATH = "#{Rails.root}/config/app_config.yml"
  APP_ENV_YML_PATH = "#{Rails.root}/config/app_env.yml"

  def self.config(key)
    self.instance.config(key)
  end

  def self.env(key)
    self.instance.env(key)
  end

  #
  # app_configの情報を取得する
  # usage: Consts.config["key_name"]
  #
  # @param [<type>] key キー
  #
  # @return [<type>] app_configデータ
  #
  def config(key)
    load_app_config if @app_config.nil?
    key = key.to_s if key.is_a?(Symbol)
    get_app_config_value(key) || @app_config[key]
  end

  #
  # 環境変数に合わせてapp_envの情報を取得する
  # usage: Consts.env["key_name"]
  #
  # @param [<type>] key キー
  #
  # @return [<type>] app_envデータ
  #
  def env(key)
    load_app_env if @app_env.nil?
    key = key.to_s if key.is_a?(Symbol)
    get_app_env_value(key) || @app_env[key]
  end

  #
  # config/app_config.ymlを読み込む
  #
  # @return [<type>] app_config.yml
  #
  def load_app_config
    @app_config = YAML.load_file(APP_CONFIG_YML_PATH).with_indifferent_access
  end

  #
  # 環境変数に合わせてconfig/app_env.ymlを読み込む
  #
  # @return [<type>] app_env.yml
  #
  def load_app_env
    @app_env = YAML.load_file(APP_ENV_YML_PATH)[Rails.env].with_indifferent_access
  end

  def get_app_config_value(key)
    @app_config[key]
  end

  def get_app_env_value(key)
    @app_env[key]
  end
end