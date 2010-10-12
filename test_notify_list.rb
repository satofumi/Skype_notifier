#!/usr/bin/env ruby

require 'Nortify_list'
nortify_list = Nortify_list.new 'nortify_messages.txt'

message, wait_second = nortify_list.next_message_and_wait_second()
p message, wait_second
