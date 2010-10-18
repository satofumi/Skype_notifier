# -*- coding: utf-8 -*-

#
#= 通知メッセージと送信タイミング管理クラス
#
# Authors:: Satofumi KAMIMURA
#
# $Id$


class Notify_list
  Timing_size = 5

  def initialize file_name
    @events = []

    # 秒数を 00 にした値を初期状態として記録する
    current_time = Time.now
    register_time = current_time - (current_time.strftime('%S').to_i)

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
        # !!! それ以外の項目も '*' でないときに所定の範囲に収まっているかを
        # !!! 確認すべき

        event = {}
        event['message'] = message
        event['timing'] = timing
        event['last_time'] = register_time
        @events.push event
      end
    }

    if @events.size == 0 then
      # イベントがなければ、メッセージを出力して終了する
      print "no message event. exit.\n"
      exit
    end
  end


  def next_message_and_wait_second
    next_event = @events[0]
    current_time = Time.now

    next_event_second = calculate_next_message_time(next_event, current_time)
    @events.each { |event|
      next_second = calculate_next_message_time(event, current_time)
      if next_second < next_event_second then
        next_event = event
        next_event_second = next_second
      end
    }

    next_event['last_time'] += next_event_second
    [next_event['message'], next_event_second]
  end


  # 次のメッセージを送信する時刻を作成する
  def calculate_next_message_time(event, current_time)

    # 所定のタイミングになるまで、最後の更新時刻に秒数を加算していく
    event_timing = event['timing']
    last_time = event['last_time']
    next_time = last_time
    next_minute, * = parse_time_items(next_time)

    event_minute = event_timing[0].to_i
    event_hour, event_day, event_month, event_wday = event_timing[1..4]

    next_time = next_time + (event_minute - next_minute) * 60
    next_minute, next_hour, next_day, next_month, next_wday, * =
      parse_time_items(next_time)

    if event_hour != '*' then
      next_time = next_time +
        ((event_hour.to_i - next_hour + 24) % 24) * 60 * 60
      next_minute, next_hour, next_day, next_month, next_wday, * =
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
      # 曜日の指定を処理
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
    %w(M H d m w Y).map {|c|
      time.strftime("%#{c}").to_i
    }
  end
  private :parse_time_items
end
