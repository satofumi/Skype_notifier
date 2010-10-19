#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Notify_list.rb のテストクラス
# Satofumi KAMIMURA
# $Id$

require 'test/unit'
require '../Notify_list'


class Notify_list_test < Test::Unit::TestCase

  # 指定時刻までの秒数が正しく計算されるかのテスト
  def test_calculate_next_message_time
    # 繰り返し呼び出したときに、秒数とメッセージが適切かを確認する
    test_time = Time.mktime(2010, 1, 1, 00, 00, 00)
    notify_list =
      Notify_list.new 'messages_for_next_message_test.txt', test_time

    # 00:01
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal("00:01", message)
    assert_equal(60, wait_second)
    test_time += wait_second

    # 00:10
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal(":10", message)
    assert_equal(60 * 9, wait_second)
    test_time += wait_second

    # 01:10
    print "\n"
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal(":10", message)
    assert_equal(60 * 60, wait_second)
    test_time += wait_second

    # 02:10
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal(":10", message)
    assert_equal(60 * 60, wait_second)
    test_time += wait_second

    # 02:20
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal("02:20", message)
    assert_equal(60 * 10, wait_second)
    test_time += wait_second

    # 03:10
    message, wait_second = notify_list.next_message_and_wait_second test_time
    assert_equal(":10", message)
    assert_equal(60 * 50, wait_second)
    test_time += wait_second
  end
end
