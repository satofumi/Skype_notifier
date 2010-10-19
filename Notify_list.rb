# -*- coding: utf-8 -*-

#
# = 通知メッセージと送信タイミング管理クラス
#
# == Authors
#   Satofumi KAMIMURA
#
# $Id$


class Notify_list
  # 分 時 日 月 曜日
  Timing_size = 5

  Timing_minute = 0
  Timing_hour = 1
  Timing_day = 2
  Timing_month = 3
  Timing_wday = 4


  def initialize(file_name, current_time = Time.now)
    @events = []

    register_time = current_time

    File.open(file_name) { |fd|
      while line = fd.gets

        # 改行のみの行、および '#' で始まるコメント行は読みとばす
        line = line.chomp
        if line.size == 0 or line[0].chr == '#' then
          next
        end

        # '"' から以降をメッセージとして扱う
        first_index = line.index('"')
        last_index = line.rindex('"')
        message = line[first_index + 1 .. last_index - 1]

        # '"' 以前をメッセージの送信タイミングとして処理する
        timing = line[0, first_index - 1].split
        if timing.size > Timing_size then
          # タイミングの項目数が異常
          print file_name + ":" + fd.lineno.to_s + " parse error.\n"
          exit
        end

        timing.fill('*', timing.size .. Timing_size)

        # !!! 分が 00 - 59 の範囲でないときに、エラーを出力して終了させる
        # !!! 日, 月 も同様
        # !!! 指定の時刻を Time のメソッドで正当かどうかを判定すればよい

        event = {}
        event['message'] = message
        event['timing'] = timing
        event['previous_time'] = register_time
        @events.push event
      end
    }

    if @events.size == 0 then
      # イベントがなければ、メッセージを出力して終了する
      print "no message event. exit.\n"
      exit
    end
  end


  def next_message_and_wait_second(current_time = Time.now)
    next_event = @events[0]

    next_event_second = calculate_next_message_time(next_event, current_time)
    @events.each { |event|
      next_second = calculate_next_message_time(event, current_time)
      if next_second < next_event_second then
        next_event = event
        next_event_second = next_second
      end
    }

    next_event['previous_time'] = current_time + next_event_second
    [next_event['message'], next_event_second]
  end


  # 次のタイミングの Time を計算し、現在の Time との差を返す
  def calculate_next_message_time(event, current_time)

    event_time = event['timing']
    previous_time = event['previous_time']
    next_time = previous_time
    next_second, next_minute, * = parse_time_items(next_time)

    event_minute, event_hour, event_day, event_month, event_wday =
      event_time[Timing_minute .. Timing_wday]
    event_minute = event_minute.to_i

    # 次のタイミングの指定された分になるまでの秒数を加算する
    next_time +=
      (60 - next_second) +
      (((event_minute - 1 - next_minute + 60) % 60) * 60)
    next_second, next_minute, next_hour, next_day, next_month, next_wday, * =
      parse_time_items(next_time)

    if event_hour != '*' then
      # 次のタイミングの指定された時になるまでの秒数を加算する
      next_time = next_time +
        ((event_hour.to_i - next_hour + 24) % 24) * 60 * 60
      next_second, next_minute, next_hour, next_day, next_month, next_wday, * =
        parse_time_items(next_time)
    end

    # 曜日の指定と日月の指定は排他で扱い、曜日の指定を優先する
    if event_wday == '*' then
      # 日月の指定を処理
      # !!!
      # !!! 月、日が翌日以降の場合は、翌月、翌日の Time を生成して
      # !!! その差分から additional_month, additional_minute を生成する
      # !!! 未実装

    else
      # '曜日' について、次に条件にマッチするタイミングを計算する
      next_time = next_time +
        ((event_wday.to_i - next_wday + 7) % 7) * 24 * 60 * 60
      if next_time < current_time then
        next_time = next_time + (7 * 24 * 60 * 60)
      end
    end

    # 現在時刻との差を返す
    next_second = next_time - current_time
    [next_second, 0].max
  end
  private :calculate_next_message_time


  def parse_time_items(time)
    %w(S M H d m w Y).map {|c|
      time.strftime("%#{c}").to_i
    }
  end
  private :parse_time_items
end
