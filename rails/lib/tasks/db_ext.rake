# -*- coding: utf-8 -*-
namespace :db do

  require 'csv'
  ActiveRecord::Base.logger = Logger.new('log/task_reload_masterdb.log')
  console = ActiveSupport::Logger.new(STDOUT)
  ActiveRecord::Base.logger.extend ActiveSupport::Logger.broadcast(console)
  logger = ActiveRecord::Base.logger

  unless Rails.env.production?
    task :refresh => [:drop, :create, :migrate, :seed]
  end

  # マスター入れ替え処理
  task :reload_master => :environment do

    logger.info '=========> start: ' + DateTime.now.strftime('%Y-%m-%d %H:%M:%S')

    ApplicationRecord.transaction do
      # m_reception_companies
      # logger.info '----------> m_reception_companies: ' + DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      # csv_path = 'db/csv/m_reception_companies.csv'
      # if File.exist?(csv_path)
      #   ActiveRecord::Base.connection.execute('TRUNCATE TABLE m_reception_companies')
      #   csv = CSV.readlines(csv_path, :col_sep => ',')
      #   csv.each do | row |
      #     MReceptionCompany.create :id => row[0], :name => row[1], :reward_type => row[2], :del_flg => row[3]
      #   end
      #   logger.info '----------> loaded.'
      # end
    end

    # キャッシュを削除する
    Rails.cache.clear

    logger.info '=========> end: ' + DateTime.now.strftime('%Y-%m-%d %H:%M:%S')

    # ApplicationController.helpers.post_chat("システム通知", "マスターをリロードしました")
  end

end
