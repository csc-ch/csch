     H**********************************************************************
     H*                                                                    *
     H*   システム名      :ＲＰＧ教育                                *
     H*   サブシステム名  :ＩＢＭリスキリング・カレッジ              *
     H*   プログラム名    : #05 便利な…LIKEREC（固定              *
     H*   プログラムＩＤ  : GOD053R@41                                 *
     H*   会　社　名　　  :株式会社中部システム                      *
     H*                                                                    *
     H*     作　成　者    :㈱中部システム Y.USHIDA                   *
     H*     作　成　日    : 2025/08/27                                 *
     H*     管　理　番　号: CSC-202507-001                             *
     H*                                                                    *
     H*     変　更　者    :　　　　　　　　　　　　　　　　　　      *
     H*     変　更　日    : ____/__/__                                 *
     H*     管　理　番　号:                                            *
     H*                                                                    *
     H*  プログラム特記事項                                              *
     H* 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　   *
     H* 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　   *
     H*                                                                    *
     H*-*******************************************************************
     H*-*Ｈ仕様書                                                      **
     H*-*******************************************************************
     H DFTACTGRP(*NO) ACTGRP(*NEW)
     H DATEDIT(*YMD)
     H DECEDIT('0.')
     H COPYRIGHT('COPYRIGHT(C) CHUBU SYSTEM CO.,LTD. ALL RIGHTS RESERVED')
     F*-*******************************************************************
     F*-*Ｆ仕様書                                                      **
     F*-*******************************************************************
     F*画面装置
     FGOD053D   CF   E             WORKSTN INDDS(IND_DSP   )
     F*商品マスタ
     FMSYOL01@4 UF   E           K DISK
     D*-********************************************************************
     D*-* Ｄ仕様書                                                      **
     D*-********************************************************************
     D*-----------------------------------
     D*プログラム状況・データ構造
     D*-----------------------------------
     D                SDS
     D S#PROC                  1     10A                                        プログラム名
     D S#STS                  11     15S 0                                      状況コード
     D S#JOB                 244    253A                                        ジョブ名
     D S#USER                254    263A                                        ユーザー名
     D S#JNBR                264    269S 0                                      ジョブ№
     D*
     D*-----------------------------------
     D*画面標識の変数マッピング
     D*-----------------------------------
     D IND_DSP         DS
     D  F03                            N   OVERLAY(IND_DSP   :03)               ＰＦ）終了
     D  F08                            N   OVERLAY(IND_DSP   :08)               ＰＦ）履歴↓
     D  F09                            N   OVERLAY(IND_DSP   :09)               ＰＦ）履歴↑
     D  F10                            N   OVERLAY(IND_DSP   :10)               ＰＦ）登録
     D  F12                            N   OVERLAY(IND_DSP   :12)               ＰＦ）戻る
     D  F23                            N   OVERLAY(IND_DSP   :23)               ＰＦ）削除
     D  PAGEUP                         N   OVERLAY(IND_DSP   :33)               ＰＦ）前ページ
     D  PAGEDOWN                       N   OVERLAY(IND_DSP   :34)               ＰＦ）次ページ
     D  ERR_ALL                        N   OVERLAY(IND_DSP   :60)               エラー）全体
     D  ERR_NO_MORE                    N   OVERLAY(IND_DSP   :61)               エラー）これより無
     D  MODE_HISTORY                   N   OVERLAY(IND_DSP   :95)               モード）履歴
     D*
     D*-----------------------------------
     D*レコード配列
     D*-----------------------------------
     D C#MAX           C                   99                                   最大要素数
     D*
     D*■画面レコード様式を”履歴管理”用に配列化
     D*　ＬＩＫＥＲＥＣ（レコード名：＊ＡＬＬ　）…レコード様式のＤＳ構造を定義
     D*　ＬＩＫＥＤＳ（ＤＳ名）…ＤＳ構造をクローン
     D*　これだけで、面倒な桁計算などが不要で構造を定義できる
     D HST             DS                  QUALIFIED
     D  G1                                  LIKEDS(G1)
     D                                      DIM(C#MAX           )
     D                                      INZ
     D*
     D G1              DS                  QUALIFIED
     D  P1                                  LIKEREC(PANEL01   :*ALL)
     D  P2                                  LIKEREC(PANEL02   :*ALL)
     D*-********************************************************************
     D*-* ＫＬＩＳＴ                                                    **
     D*-********************************************************************
     D  MSYOL01_KEY1   DS                  LIKEREC(MSYOR  : *KEY  ) INZ
     D*-********************************************************************
     D*-* 変数定義                                                      **
     D*-********************************************************************
     D  WTIMESTAMP     S             26Z                                        タイムスタンプ
     D  WDATE8         S              8S 0                                      日付
     D  WTIME6         S              6S 0                                      時刻
     D*
     D  W#CTL          S             10A                                        画面制御
     D*
     D  W#HC1          S              3S 0 INZ                                  履歴（最大
     D  W#HC2          S              3S 0 INZ                                  履歴（現在
     C*-********************************************************************
     C*-* メインルーチン                                                **
     C*-********************************************************************
     C*初期処理
     C                   EXSR      @INZ
     C*
     C                   DOW       *ON
     C*
     C                   SELECT
     C                   WHEN      W#CTL       = 'PANEL01'
     C                   EXSR      @PANEL01
     C                   WHEN      W#CTL       = 'PANEL02'
     C                   EXSR      @PANEL02
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
     C*
     C                   ENDDO
     C*
     C*終了処理
     C                   EXSR      @END
     C*-***************************************************************
     C*-* @INZ        初期処理                                     **
     C*-***************************************************************
     C     @INZ          BEGSR
     C*
     C*システム日付
     C                   EVAL      WTIMESTAMP =  %TIMESTAMP()
     C                   EVAL      WDATE8     =  %DEC(%DATE(WTIMESTAMP) : *ISO )システム日付
     C                   EVAL      WTIME6     =  %DEC(%TIME(WTIMESTAMP) : *HMS )システム時刻
     C*
     C                   EVAL      G1.P1.D1PGM      = S#PROC                    ＰＧＭ－ＩＤ
     C*
     C                   EVAL      W#CTL      =  'PANEL01'                      画面制御
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @PANEL01    画面処理（見出し                             **
     C*-***************************************************************
     C     @PANEL01      BEGSR
     C*
     C                   EVAL      D3MSG      =  'F3=終了+                    メッセージ
     C                                            ,PAGEUP:前+
     C                                            /PAGEDOWN:次+
     C                                            ,F8=履歴↓+
     C                                            ,F9=履歴↑'
     C*
     C                   EVAL      MODE_HISTORY = *OFF
     C*
     C                   WRITE     PANEL03
     C                   EXFMT     PANEL01       G1.P1
     C*
     C                   EVAL      G1.P1.D1MSG   = *BLANK                       メッセージ
     C                   EVAL      ERR_ALL       = *OFF
     C                   EVAL      ERR_NO_MORE   = *OFF
     C*
     C                   IF        F03        = *ON
     C                   EVAL      W#CTL      =  'END'                          画面制御
     C                   LEAVESR
     C                   ENDIF
     C*
     C*前を取得
     C                   IF        PAGEUP     = *ON
     C                   EXSR      @UP
     C                   LEAVESR
     C                   ENDIF
     C*次を取得
     C                   IF        PAGEDOWN   = *ON
     C                   EXSR      @DOWN
     C                   LEAVESR
     C                   ENDIF
     C*
     C*履歴（↓
     C                   IF        F08        = *ON
     C                   EVAL      W#HC2        -= 1                            履歴（現在
     C                   EXSR      @HISTORY
     C*    履歴が見つかった
     C                   IF        NOT ERR_ALL
     C                   EVAL      W#CTL      =  'PANEL02'                      画面制御
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
     C*
     C*履歴（↑
     C                   IF        F09        = *ON
     C                   EVAL      W#HC2        += 1                            履歴（現在
     C                   EXSR      @HISTORY
     C*    履歴が見つかった
     C                   IF        NOT ERR_ALL
     C                   EVAL      W#CTL      =  'PANEL02'                      画面制御
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
     C*
     C*入力チェック
     C                   EXSR      @CHK1
     C*    商品が見つからない
     C                   IF        ERR_ALL
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      W#CTL      =  'PANEL02'                      画面制御
     C*
     C*画面項目セット（明細
     C                   EXSR      @SET2
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @UP         前を取得                                     **
     C*-***************************************************************
     C     @UP           BEGSR
     C*
     C* 開始キー位置づけ
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = G1.P1.I1SYCODE     商品コード
     C     MSYOL01_KEY1  SETLL     MSYOR
     C                   READP(N)  MSYOR
     C                   IF        NOT %EOF
     C                   EVAL      G1.P1.I1SYCODE          =  MSYOSYCODE        商品コード
     C                   ELSE
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      G1.P1.D1MSG = 'これ以上ありません。'       メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @DOWN       次を取得                                     **
     C*-***************************************************************
     C     @DOWN         BEGSR
     C*
     C* 開始キー位置づけ
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = G1.P1.I1SYCODE     商品コード
     C     MSYOL01_KEY1  SETGT     MSYOR
     C                   READ(N)   MSYOR
     C                   IF        NOT %EOF
     C                   EVAL      G1.P1.I1SYCODE          =  MSYOSYCODE        商品コード
     C                   ELSE
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      G1.P1.D1MSG = 'これ以上ありません。'       メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @HISTORY    履歴取得                                     **
     C*-***************************************************************
     C     @HISTORY      BEGSR
     C*
     C*履歴がない
     C                   IF        W#HC1      <= *ZERO
     C                   EVAL      ERR_ALL       = *ON
     C                   EVAL      W#HC2         = *ZERO                        履歴（現在
     C                   EVAL      G1.P1.D1MSG = '登録履歴はありません'       メッセージ
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      MODE_HISTORY = *ON
     C*
     C*下限
     C                   IF        W#HC2      <= *ZERO
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      W#HC2         = W#HC1                        履歴（現在
     C                   EVAL      G1.P1.D1MSG = '履歴の最後へ戻りました'     メッセージ
     C                   ENDIF
     C*
     C*上限
     C                   IF        W#HC2       > W#HC1
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      W#HC2         = 1                            履歴（現在
     C                   EVAL      G1.P1.D1MSG = '履歴の先頭へ戻りました'     メッセージ
     C                   ENDIF
     C*
     C*-画面にセット
     C                   EVAL      G1.P1.I1SYCODE = HST.G1(W#HC2 ).P1.I1SYCODE  画面１
     C                   EVAL      G1.P2          = HST.G1(W#HC2 ).P2           画面２
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @CHK1       チェック（見出                               **
     C*-***************************************************************
     C     @CHK1         BEGSR
     C*
     C* 商品マスタ参照
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = G1.P1.I1SYCODE     商品コード
     C     MSYOL01_KEY1  CHAIN(N)  MSYOR
     C                   IF        NOT %FOUND
     C                   EVAL      ERR_ALL       = *ON
     C                   EVAL      G1.P1.D1MSG = '該当の商品が存在しません。' メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @SET2       画面項目セット                               **
     C*-***************************************************************
     C     @SET2         BEGSR
     C*
     C                   EVAL      G1.P2.D2SYNAME  = MSYOSYNAME                 商品名（正式）
     C                   EVAL      G1.P2.D2SYTANK1 = MSYOSYTANK                 販売単価
     C                   EVAL      G1.P2.D2SYTANK2 = MSYOSYTANK * 0.6           仕入単価
     C*
     C                   EVAL      G1.P2.D2ZEIKBN  = MSYOZEIKBN                 税区分
     C*
     C                   EVAL      G1.P2.D2SU11  = 12345                        当月売上数量
     C                   EVAL      G1.P2.D2SU12  = G1.P2.D2SU11 * 12            当年売上数量
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @PANEL02    画面処理（明細                               **
     C*-***************************************************************
     C     @PANEL02      BEGSR
     C*
     C                   EVAL      D3MSG      =  'F3=終了+                    メッセージ
     C                                            ,F12=戻る+
     C                                            ,PAGEUP:前+
     C                                            /PAGEDOWN:次+
     C                                            ,F10=登録+
     C                                            ,F23=削除'
     C*
     C                   IF        MODE_HISTORY = *ON
     C                   EVAL      D3MSG      =  'F3=終了+                    メッセージ
     C                                            ,F12=戻る+
     C                                            ,F8=履歴↓+
     C                                            ,F9=履歴↑'
     C                   ENDIF
     C*
     C                   WRITE     PANEL03
     C                   WRITE     PANEL01       G1.P1
     C                   EXFMT     PANEL02       G1.P2
     C*
     C                   EVAL      G1.P1.D1MSG = *BLANK                         メッセージ
     C                   EVAL      ERR_ALL       = *OFF
     C                   EVAL      ERR_NO_MORE   = *OFF
     C*
     C                   IF        F03        = *ON
     C                   EVAL      W#CTL      =  'END'                          画面制御
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   IF        F12        = *ON
     C                   EVAL      W#CTL      =  'PANEL01'                      画面制御
     C                   LEAVESR
     C                   ENDIF
     C*
     C*前を取得
     C                   IF        NOT MODE_HISTORY   AND
     C                               PAGEUP
     C                   EXSR      @UP
     C                   EXSR      @SET2
     C                   LEAVESR
     C                   ENDIF
     C*次を取得
     C                   IF        NOT MODE_HISTORY   AND
     C                               PAGEDOWN
     C                   EXSR      @DOWN
     C                   EXSR      @SET2
     C                   LEAVESR
     C                   ENDIF
     C*
     C*履歴（↓
     C                   IF        F08        = *ON
     C                   SUB       1             W#HC2                          履歴（現在
     C                   EXSR      @HISTORY
     C                   LEAVESR
     C                   ENDIF
     C*
     C*履歴（↑
     C                   IF        F09        = *ON
     C                   ADD       1             W#HC2                          履歴（現在
     C                   EXSR      @HISTORY
     C                   LEAVESR
     C                   ENDIF
     C*
     C*削除
     C                   IF        F23        = *ON
     C                   EXSR      @DEL
     C                   EVAL      W#CTL      =  'PANEL01'                      画面制御
     C                   LEAVESR
     C                   ENDIF
     C*
     C*入力チェック
     C                   EXSR      @CHK2
     C                   IF        ERR_ALL
     C                   LEAVESR
     C                   ENDIF
     C*
     C*更新
     C                   IF        F10        = *ON
     C                   EXSR      @UPD
     C                   EVAL      W#CTL      =  'PANEL01'                      画面制御
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @CHK2       チェック（明細                               **
     C*-***************************************************************
     C     @CHK2         BEGSR
     C*
     C                   EVAL      G1.P2.D2SYTANK2 = G1.P2.D2SYTANK1  * 0.6     仕入単価
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @UPD        更新処理                                     **
     C*-***************************************************************
     C     @UPD          BEGSR
     C*
     C* 商品マスタ参照
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = G1.P1.I1SYCODE     商品コード
     C     MSYOL01_KEY1  CHAIN     MSYOR
     C                   IF        NOT %FOUND
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      MSYOSYNAME      = G1.P2.D2SYNAME             商品名（正式）
     C                   EVAL      MSYOSYTANK      = G1.P2.D2SYTANK1            販売単価
     C                   EVAL      MSYOZEIKBN      = G1.P2.D2ZEIKBN             税区分
     C                   UPDATE    MSYOR
     C*
     C* 登録履歴最大となった
     C                   IF        W#HC1        >= C#MAX
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      G1.P2.D2MODE  = '更新'                     処理モード
     C                   EVAL      W#HC1        += 1                            履歴（最大
     C*
     C*-履歴に追加
     C                   EVAL      G1.P2.D2HSTI = W#HC1                         ＩＮＤＥＸ
     C                   EVAL      HST.G1(W#HC1 ).P1 = G1.P1                    画面１
     C                   EVAL      HST.G1(W#HC1 ).P2 = G1.P2                    画面２
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @DEL        削除処理                                     **
     C*-***************************************************************
     C     @DEL          BEGSR
     C*
     C* 商品マスタ参照
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = G1.P1.I1SYCODE     商品コード
     C     MSYOL01_KEY1  CHAIN     MSYOR
     C                   IF        NOT %FOUND
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   DELETE    MSYOR
     C*
     C* 登録履歴最大となった
     C                   IF        W#HC1        >= C#MAX
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      G1.P2.D2MODE  = '削除'                     処理モード
     C                   EVAL      W#HC1        += 1                            履歴（最大
     C*
     C*-履歴に追加
     C                   EVAL      G1.P2.D2HSTI = W#HC1                         メッセージ
     C                   EVAL      HST.G1(W#HC1 ).P1 = G1.P1                    画面１
     C                   EVAL      HST.G1(W#HC1 ).P2 = G1.P2                    画面２
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @END        終了処理                                     **
     C*-***************************************************************
     C     @END          BEGSR
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*
     C                   ENDSR
