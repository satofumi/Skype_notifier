===== これは何？ =====
Skype のグループに定期的にメッセージを自動送信するためのスクリプトです。
Windows 上の 1.8.x 系の Ruby で動作し、Ruby4Skype モジュールが必要です。


===== インストール =====
1. Windows で作業を行います。
2. Skype をインストールし、起動しておきます。
3. メッセージを送信したいグループを "コンタクトにグループを保存" します。
   グループに保存された最初のコンタクトに、メッセージを送信します。

4. 1.8.x 系の Ruby をインストールします。(RubyInstaller など)
5. 以下のコマンドにて Ruby4Skype をインストールします。

gem install Ruby4Skype

6. 'notify_messages.txt' を編集します。フォーマットは crontab と同じです。
7. 以下のコマンドでスクリプトを起動します。

ruby -I . skype_notifier.rb

以上です。


===== Todo =====
- 日, 月 の項目に数値があるときの処理が未実装なのを修正する。
- crontab の色々な記述方法が使えないのを実装する。
- ちゃんと動作確認する。


===== 連絡先 =====
- satofumi@hyakuren-soft.sakura.ne.jp
