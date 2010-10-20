===== これは何？ =====
Skype のグループに定期的にメッセージを自動送信するためのスクリプトです。
Windows 上の 1.8.x 系の Ruby で動作します。


==== ライセンス =====
Ruby ライセンスです。


===== インストール =====
1. Windows で作業を行います。

2. 1.8.x 系の RubyInstall をインストールします。
   http://rubyinstaller.org/

3. 以下のコマンドにて Ruby4Skype をインストールします。

gem install Ruby4Skype

4. swin.so を Skype_notifier フォルダに配置します。
   swin.so は以下パッケージ中の lib/ruby/site_ruby/1.8/i386-msvcrt/ にあります。
   ftp://ftp.ruby-lang.org/pub/ruby/binaries/mswin32/ext/vrswin-060205-i386-mswin32-1.8.zip

5. 'notify_messages.txt' を編集します。フォーマットは crontab と同じです。

6. Skype をインストールし、起動しておきます。
7. メッセージを送信したいグループを "コンタクトにグループを保存" します。
   グループに保存された最初のコンタクトに、メッセージを送信します。

8. 以下のコマンドでスクリプトを起動します。

ruby -I . skype_notifier.rb

以上です。


===== Todo =====
- '*' を省略したときに適切に動作するかを確認する
- 月、日に数値を指定したときの処理を実装し、動作を確認する


===== 連絡先 =====
- satofumi@users.sourceforge.jp
