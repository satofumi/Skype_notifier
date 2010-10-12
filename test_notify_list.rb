#!/usr/bin/env ruby

require 'Notify_list'
notify_list = Notify_list.new 'notify_messages.txt'

message, wait_second = notify_list.next_message_and_wait_second()
p message, wait_second
