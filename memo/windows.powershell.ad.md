# Setup Active Directory on CLI

## 新規フォレスト及びドメインコントローラーの構築

### 前提条件
- OS が Windows Server 2012 R2 であること
- ビルトイン Administrator ユーザでログインできること
- サーバに静的IPアドレスが設定済みであること
- サーバにホスト名が設定済みであること

### 確認
```
# 作業対象サーバを確認する。
hostname

# ビルトイン Administrator ユーザでログインしていることを確認する。
whoami
```

### 作業
```
# ServerManager モジュールをインポートする。
Import-Module ServerManager

# Active Directory Domain Services をインストールする。
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services
```

```
# ADDSDeployment モジュールをインポートする。
Import-Module ADDSDeployment

# 設定値(後段で使用)：ADで使用するドメイン
$addsDomainName = "report.local"

# 設定値(後段で使用)：ADで使用するドメインのNetBIOS名
$addsDomainNetbiosName = "REPORT"

# 設定値(後段で使用)：作成するフォレストの機能レベル
$addsForestMode = "Win2012R2"

# 設定値(後段で使用)：作成するドメインの機能レベル
$addsDomainMode = "Win2012R2"

# 設定値(後段で使用)：セーフモード起動時のAdministratorユーザのパスワード
$addsAdminPassword = "P@ssw0rd"

# 設定値(後段で使用)：ADのデータベース格納パス
$addsDatabasePath = "C:\Windows\NTDS"

# 設定値(後段で使用)：ADのトランザクションログ格納パス
$addsLogPath = "C:\Windows\NTDS"

# 設定値(後段で使用)：システムボリュームのパス
$addsSysvolPath = "C:\Windows\SYSVOL"

# 設定値(後段で使用)：DNSをインストールする
$addsInstallDns = $True

# 設定値(後段で使用)：DNS委任を作成しない
$addsCreateDnsDelegation = $false

# 設定値(後段で使用)：完了後にコンピュータを再起動させる
$addsNoRebootOnCompletion = $false

# 新規フォレスト及びドメインコントローラーを構築
Install-ADDSForest `
    -DomainName $addsDomainName `
    -DomainNetbiosName $addsDomainNetbiosName `
    -ForestMode $addsForestMode `
    -DomainMode $addsDomainMode `
    -DatabasePath $addsDatabasePath `
    -LogPath $addsLogPath `
    -SysvolPath $addsSysvolPath `
    -SafeModeAdministratorPassword $addsSafeModePasswordSecure `
    -InstallDns:$addsInstallDns `
    -CreateDnsDelegation:$addsCreateDnsDelegation `
    -NoRebootOnCompletion:$addsNoRebootOnCompletion






```



