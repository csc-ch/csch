     H DATEDIT(*YMD)
     F*******************************************************************
     F** #05 便利な…PREFIX                           << GOD051R>>   **
     F**                       WRITTEN  25/08/27 BY CSC Y.USHIDA       **
     F**                       UPDATE   XX/XX/XX BY XXX X.XXXXXXXX     **
     F**--------------- PROGRAM DESCRIPTION ---------------------------**
     F*******************************************************************
     F*-----<<ファイル定義>>-----*
     F*商品マスタ（カナ順
     FMSYOL02   IF   E           K DISK
     F                                     RENAME(MSYOR:MSYOR02)
     F*商品マスタ（コード順
     FMSYOL01   UF   E           K DISK
     F                                     RENAME(MSYOR:MSYOR01)
     D*******************************************************************
     D                SDS
     D  S#PROC                 1     10
     D  S#STS                 11     15  0
     D  S#JOB                244    253
     D  S#USER               254    263
     D  S#JNBR               264    269  0
     I*-----<<テーフ゛ル定義>>-----*
     I*******************************************************************
     I*-----<<リネーム定義>>-----*
     I*■ＣＶＴしても
     I*”Ｉ仕様書”部分の非効率は変わらない
     I*　レコードのフィールド毎のリネームを一つずつ記述しなければならない
     I*　フィールドの増減に対して、ソースの改変が必要となる
     I*　同じＩ仕様書でもデータ構造より前に記述というルールがある
     IMSYOR01
     I              MSSYHN                      M1SYHN
     I              MSSYNM                      M1SYNM
     I              MSSYKN                      M1SYKN
     I              MSSYTN                      M1SYTN
     I              MSZEIK                      M1ZEIK
     I              MSUPDT                      M1UPDT
     I              MSUPTM                      M1UPTM
     I              MSUPPG                      M1UPPG
     C*******************************************************************
     C**        KLIST                                                  **
     C*******************************************************************
     C     M1KEY1        KLIST
     C                   KFLD                    M1SYHN
     C*******************************************************************
     C**        M A I N   R O U T I N E                                **
     C*******************************************************************
     C*
     C                   EXSR      @INZ
     C*
     C*■ＣＶＴしても
     C*　標識やＲＰＧⅢ由来の命令や記述は変わらず、最適化や見通しが悪い
     C*
     C     1             DO        3
     C                   READ      MSYOR02                                90
     C   90              LEAVE
     C*
     C     MSSYHN        CAT       MSSYKN:1      W#MSG1           48            メッセージ
     C*
     C     W#MSG1        DSPLY
     C*
     C                   MOVEL     MSSYHN        M1SYHN                         商品コード
     C     M1KEY1        CHAIN     MSYOR01                            55
     C   55              ITER
     C*
     C                   Z-ADD     WDATE8        M1UPDT                         更新日付
     C                   Z-ADD     WTIME6        M1UPTM                         更新時刻
     C                   MOVEL     S#PROC        M1UPPG                         更新ＰＧＭ
     C                   UPDATE    MSYOR01
     C*
     C                   ENDDO
     C*
     C                   EXSR      @END
     C*
     C*******************************************************************
     C**                  初期処理                                   **
     C*******************************************************************
     C     @INZ          BEGSR
     C*
     C                   TIME                    WTIME            14 0
     C                   MOVEL     WTIME         WTIME6            6 0
     C                   MOVE      WTIME         WDATE8            8 0
     C*
     C                   ENDSR
     C*******************************************************************
     C**                  終了処理                                   **
     C*******************************************************************
     C     @END          BEGSR
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*
     C                   ENDSR
