     H**********************************************************************
     H*                                                                    *
     H*   システム名      :ＲＰＧ教育                                *
     H*   サブシステム名  :ＩＢＭリスキリング・カレッジ              *
     H*   プログラム名    : #04 標識の呪縛（固定                     *
     H*   プログラムＩＤ  : GOD041R@41                                 *
     H*   会　社　名　　  :株式会社中部システム                      *
     H*                                                                    *
     H*     作　成　者    :㈱中部システム Y.USHIDA                   *
     H*     作　成　日    : 2025/08/12                                 *
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
     FGOD041D   CF   E             WORKSTN INDDS(IND_DSP   )
     F*商品マスタ
     FMSYOL01@4 IF   E           K DISK
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
     D  F12                            N   OVERLAY(IND_DSP   :12)               ＰＦ）戻る
     D  PAGEUP                         N   OVERLAY(IND_DSP   :33)               ＰＦ）前ページ
     D  PAGEDOWN                       N   OVERLAY(IND_DSP   :34)               ＰＦ）次ページ
     D  ERR_NOT_FOUND                  N   OVERLAY(IND_DSP   :60)               エラー）商品なし
     D  ERR_NO_MORE                    N   OVERLAY(IND_DSP   :61)               エラー）これより無
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
     C                   EVAL      D1PGM      =  S#PROC                         ＰＧＭ－ＩＤ
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
     C                                            /PAGEDOWN:次'
     C*
     C                   WRITE     PANEL03
     C                   EXFMT     PANEL01
     C*
     C                   EVAL      D1MSG      =  *BLANK                         メッセージ
     C                   EVAL      ERR_NOT_FOUND = *OFF
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
     C*入力チェック
     C                   EXSR      @CHK1
     C*    商品が見つからない
     C                   IF        ERR_NOT_FOUND
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
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = I1SYCODE           商品コード
     C     MSYOL01_KEY1  SETLL     MSYOR
     C                   READP     MSYOR
     C                   IF        NOT %EOF
     C                   EVAL      I1SYCODE   =  MSYOSYCODE                     商品コード
     C                   ELSE
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      D1MSG      =  'これ以上ありません。'       メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @DOWN       次を取得                                     **
     C*-***************************************************************
     C     @DOWN         BEGSR
     C*
     C* 開始キー位置づけ
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = I1SYCODE           商品コード
     C     MSYOL01_KEY1  SETGT     MSYOR
     C                   READ      MSYOR
     C                   IF        NOT %EOF
     C                   EVAL      I1SYCODE   =  MSYOSYCODE                     商品コード
     C                   ELSE
     C                   EVAL      ERR_NO_MORE   = *ON
     C                   EVAL      D1MSG      =  'これ以上ありません。'       メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @CHK1       チェック（見出                               **
     C*-***************************************************************
     C     @CHK1         BEGSR
     C*
     C* 商品マスタ参照
     C                   EVAL      MSYOL01_KEY1.MSYOSYCODE = I1SYCODE           商品コード
     C     MSYOL01_KEY1  CHAIN     MSYOR
     C                   IF        NOT %FOUND
     C                   EVAL      ERR_NOT_FOUND = *ON
     C                   EVAL      D1MSG      =  '該当の商品が存在しません。' メッセージ
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @SET2       画面項目セット                               **
     C*-***************************************************************
     C     @SET2         BEGSR
     C*
     C                   EVAL      D2SYNAME      = MSYOSYNAME                   商品名（正式）
     C                   EVAL      D2SYTANK1     = MSYOSYTANK                   販売単価
     C                   EVAL      D2SYTANK2     = MSYOSYTANK * 0.6             仕入単価
     C*
     C                   EVAL      D2ZEIKBN      = MSYOZEIKBN + ' :'            税区分
     C                   SELECT
     C                   WHEN      MSYOZEIKBN  = '01'
     C                   EVAL      D2ZEIKBN      = %TRIM(D2ZEIKBN  )            税区分
     C                                           + '不課税'
     C                   WHEN      MSYOZEIKBN  = '02'
     C                   EVAL      D2ZEIKBN      = %TRIM(D2ZEIKBN  )            税区分
     C                                           + '非課税'
     C                   WHEN      MSYOZEIKBN  = '11'
     C                   EVAL      D2ZEIKBN      = %TRIM(D2ZEIKBN  )            税区分
     C                                           + '消費税一般'
     C                   WHEN      MSYOZEIKBN  = '12'
     C                   EVAL      D2ZEIKBN      = %TRIM(D2ZEIKBN  )            税区分
     C                                           + '消費税軽減'
     C                   ENDSL
     C*
     C                   EVAL      D2SU11        = 12345                        当月売上数量
     C                   EVAL      D2SU12        = D2SU11 * 12                  当年売上数量
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
     C                                            /PAGEDOWN:次'
     C*
     C                   WRITE     PANEL03
     C                   WRITE     PANEL01
     C                   EXFMT     PANEL02
     C*
     C                   EVAL      D1MSG      =  *BLANK                         メッセージ
     C                   EVAL      ERR_NOT_FOUND = *OFF
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
     C                   IF        PAGEUP     = *ON
     C                   EXSR      @UP
     C                   EXSR      @SET2
     C                   LEAVESR
     C                   ENDIF
     C*次を取得
     C                   IF        PAGEDOWN   = *ON
     C                   EXSR      @DOWN
     C                   EXSR      @SET2
     C                   LEAVESR
     C                   ENDIF
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
