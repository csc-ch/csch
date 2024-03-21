# CS.ch - 002 IBM i のデータベース

## サンプルコードの復元方法

YouTube 本編で使用しているサンプルコードを以下の手順で復元できます。

※**hoge** や **fuga** は任意の名前です

1. SAVF（CSCH@___.SAVF） を github よりダウンロード。**※ファイルの詳細を開いて右上の「・・・」箇所をクリック →[Download Ctrl Shift S]よりダウンロードする**
2. IBM i 側の 5250 エミュレータで SAVF を作成する。`CRTSAVF hogeLIB/fugaSAVF`
3. Widows のコマンド・プロントの FTP で IBM i へアップロードする例

```bat
CD "ダウンロードしたSAVF"が存在するディレクトリへ移動
FTP IBMiアドレス

IBMiユーザー
IBMiパスワード
↑ログイン出来ない場合はFTPが許可されていない場合があります

BIN
put CSCH@___.SAVF /QSYS.LIB/hogeLIB.LIB/fugaSAVF.FILE
```

4. IBM i 側の 5250 エミュレータで SAV よりオブジェクトを復元する

```CLLE
RSTOBJ OBJ(*ALL) SAVLIB(CSCH@002) DEV(*SAVF)
 SAVF(HOGELIB/FUGASAVF)
 MBROPT(*ALL) ALWOBJDIF(*ALL) RSTLIB(CSCH@002)
```
