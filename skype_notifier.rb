#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

#
# == Synposis
# Skype に指定したときにメッセージを出力するスクリプト
#
# == Usage
#    ruby skype_notifier.rb [notify_message_file]
#
# notify_message_file:
#
#    crontab 形式で通知タイミングとメッセージを記述します。
#    例)
#        # 項目の並びは '分 時 日 月 曜日 "メッセージ"' です。
#        # '*' は任意の値にマッチすます。
#        00 7 * * * "7:00 です。"
#        00 12 * * * "12:00 です。"
#        50 20 * * * "20:50 です。"
#
#        # 曜日の指定では 0 から 7 が 日 から 土 に対応します。
#        00 8 * * 4 "毎週木曜日の 8:00 です。"
#
# == Authors
# Satofumi KAMIMURA
#
#--
# $Id$

require 'rubygems'
require 'Skype'
require 'Notify_list'


# 起動済みの Skype に接続
Skype.init 'Skype Notifier'
Skype.attachWait

# 設定ファイルの読み込み
# !!! 設定ファイルを引数で渡せるようにする
notify_list = Notify_list.new 'notify_messages.txt'

# コンタクトに登録されているグループを取得し、メッセージを送信する
# 最初のコンタクトを使うので、"コンタクトにグループを保存" するのは
# １つにしておかなくてはならない
# !!! グループ名の変更がなければ、名前を取得して判別することもできるが、未実装
chat = Skype.searchBookMarkedChats[0]

while true do
  # 指定されただけ待機し、メッセージを送信する
  message, wait_second = notify_list.next_message_and_wait_second()
  sleep wait_second

  Skype::ChatMessage.create chat, message
end
