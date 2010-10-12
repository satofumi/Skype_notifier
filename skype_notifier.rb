#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Skype に指定したときにメッセージを出力するスクリプト
# Satofumi KAMIMURA
# $Id$

require 'rubygems'
require 'Skype'
require 'Notify_list'


# 起動済みの Skype に接続
Skype.init 'Skype Notifier'
Skype.attachWait

# 設定ファイルの読み込み
notify_list = Notify_list.new 'notify_messages.txt'

# コンタクトに登録されているグループを取得し、メッセージを送信する
# 最初のコンタクトを使うので、"コンタクトにグループを保存" するのは
# １つにしておかなくてはならない
# !!! グループ名の変更がなければ、名前を取得して判別することもできるが、未実装
chat = Skype.searchBookMarkedChats[0]

while true do
  # 指定されただけ待機し、メッセージを送信する
  message, wait_second = notify_list.next_message_and_wait_second()
  p message, wait_second
  sleep wait_second
  print "test"
  exit

  Skype::ChatMessage.create chat, message
end
