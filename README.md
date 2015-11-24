
#ShareFast Web 設定手順
######2015/11/24 作成


##1. 前提条件
本アプリケーションの実行には別途「KASHIWADE」アプリケーションが必要です。
「KASHIWADE」のセットアップが済んでいない方は, 以下からセットアップしてください。

[https://sourceforge.net/projects/kashiwade/](https://sourceforge.net/projects/kashiwade/)


##2. 設定項目（必須）：「KASHIWADE」サーバ情報の設定
「sfweb\src\main\webapp\resources\js\uri.js」内に記述されている「KASHIWADE_BASE_URL」を自身の環境に合わせて修正してください。
合わせて「GROUP＿NAME」についても, 自由に変更してください。ファイル登録時のメタデータの一つとなります。

##3. 設定項目（任意）：ユーザ情報の設定
「sfweb\src\main\webapp\WEB-INF\spring\security.xml」内にログインユーザ情報が記載されています。
必要に応じてユーザの登録や, 権限の変更を行ってください。