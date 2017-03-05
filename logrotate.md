# /etc/logrotate.conf

|設定値|説明|備考|
|--:|:--|:--|
|create|古いログフィアルをローテーション後に、空のログファイルを新規作成。|必須|
|create 0644 user group|`create`時、ファイルのパーミッション、ユーザー名、グループ名を指定。|必須|
|daily|日次でログローテーションを行う|必須|
|weekly|週次でログローテーションを行う||
|monthly|月次でログローテーションを行う||
|rotate 90|90世代を保存|必須|
|ifempty|ログファイルが空でもローテーションする|必須|
|missingok|ログファイルが存在しなくてもエラーを出さずに処理を続行|必須|
|dateext|ログローテーションを行う際、ファイル末尾に日付を付与|必須|
|compress|ログローテーションを行う際、`gzip`にて圧縮|必須|
|delaycompress|ログの圧縮を次回のローテーション時まで遅らせる。<br>`compress`と共に指定。|必須|
|sharedscripts|複数指定したログファイル(`*log`など)に対し、<br>`postrotate`または`prerotate`で記述したコマンドを実行|必須|

# Ex.

    /var/log/httpd/*log {
        create
        daily
        rotate 90
        ifempty
        missingok
        dateext
        compress
        delaycompress
        sharedscripts
        postrotate
            /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
        endscript
    }



