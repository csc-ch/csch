     H*-------------------------------------------------------------------------
     H*■解決
     H*　ＲＰＧⅢより洗練されたＲＰＧⅣの命令を使用してスマートに記述する
     H*　コールドリーディングのしやすさ＝保守のしやすさ
     H*-------------------------------------------------------------------------
     H**********************************************************************
     H*                                                                    *
     H*   システム名      :ＲＰＧ教育                                *
     H*   サブシステム名  :ＩＢＭリスキリング・カレッジ              *
     H*   プログラム名    : #06 便利な命令                           *
     H*   プログラムＩＤ  : GOD061R@41                                 *
     H*   会　社　名　　  :株式会社中部システム                      *
     H*                                                                    *
     H*     作　成　者    :㈱中部システム Y.USHIDA                   *
     H*     作　成　日    : 2025/09/02                                 *
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
     D*-********************************************************************
     D*-* ＫＬＩＳＴ                                                    **
     D*-********************************************************************
     D  MSYOL01_KEY1   DS                  LIKEREC(MSYOR  : *KEY  ) INZ
     D*-********************************************************************
     D*-* 変数定義                                                      **
     D*-********************************************************************
     D*商品マスタ・レコード
     D REC1            DS                  LIKEREC(MSYOR     : *ALL )
     D*
     D MY_RECS         DS                  QUALIFIED DIM(*AUTO   :100 )
     D  MSYOSYCODE                         LIKE(MSYOSYCODE   )
     D  MSYOSYTANK                         LIKE(MSYOSYTANK   )
     D  MY_COL1                       7S 0                                      自前定義列
     D*
     D W#MSG1          S             48A   INZ                                  メッセージ
     D*
     D W#STR1          S             48A   INZ                                  文字列１
     D W#STR2          S             48A   INZ                                  文字列２
     D*
     D W#TANKBN        S              2A   INZ                                  単価区分
     D W#NEBIKI        S              3S 0 INZ                                  値引率％
     D*
     D W#REC           DS                  LIKEDS(MY_RECS     )                 自前定義列
     C*-********************************************************************
     C*-* メインルーチン                                                **
     C*-********************************************************************
     C*初期処理
     C                   EXSR      @INZ
     C*
     C                   EXSR      @EVAL
     C*
     C                   EXSR      @EVAL_CORR
     C*
     C                   EXSR      @LEAVESR
     C*
     C                   EXSR      @ELSEIF
     C*
     C                   EXSR      @SELECT
     C*
     C                   EXSR      @FOR_EACH
     C*
     C                   EXSR      @NOT
     C*
     C*終了処理
     C                   EXSR      @END
     C*-***************************************************************
     C*-* @INZ        初期処理                                     **
     C*-***************************************************************
     C     @INZ          BEGSR
     C*
     C*システム日付
     C                   TIME                    WTIME            14 0
     C                   MOVEL     WTIME         WTIME6            6 0
     C                   MOVE      WTIME         WDATE8            8 0
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @EVAL       ＥＶＡＬ                                     **
     C*-***************************************************************
     C     @EVAL         BEGSR
     C*
     C*■評価
     C*  長い文字列の表現等の相性が良い
     C*  ＲＰＧⅢでは長いリテラル文字列が記述できないため
     C*    コンパイル時テーブルやＣＡＴ命令を使用していたがスマートに記述できる
     C                   EVAL      W#STR1      = '長～～～～～～～い+
     C                                            文字列'
     C                   EVAL      W#MSG1      = W#STR1
     C     W#MSG1        DSPLY
     C*
     C*■文字列表現のＢＩＦ（組み込み関数）とも相性が良い
     C                   EVAL      W#STR2      = '○△□×'
     C                   EVAL      W#MSG1      = %TRIM(W#STR1    )
     C                                         + W#STR2
     C     W#MSG1        DSPLY
     C*
     C                   EVAL      W#STR1      = '2 * 4＝'
     C                   EVAL      W#MSG1      = %TRIM(W#STR1    )
     C                                         + %CHAR(2 * 4 )
     C     W#MSG1        DSPLY
     C*
     C                   EVAL      W#STR1      = '128 * 8＝'
     C                   EVAL      W#MSG1      = %TRIM(W#STR1    )
     C                                         + %EDITC( 128 * 8 :'N')
     C     W#MSG1        DSPLY
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @EVAL_CORR  ＥＶＡＬ－ＣＯＲＲ                           **
     C*-***************************************************************
     C     @EVAL_CORR    BEGSR
     C*
     C                   DO        *HIVAL
     C                   READ      MSYOR         REC1
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF
     C*
     C                   IF        %ELEM(MY_RECS )
     C                               >= %ELEM(MY_RECS : *MAX )
     C                   LEAVE
     C                   ENDIF
     C*
     C*■サブフィールド名が一致する項目を一括でセットすることができる
     C*  項目数の多いＤＤＳのクローン等で”ＭＯＶＥＬ”や”Ｚ－ＡＤＤ”を大量に記述する必要がない
     C                   EVAL-CORR MY_RECS(*NEXT) = REC1
     C*
     C*■ＥＶＡＬだと一項目ずつセットする必要がある
     C***                   EVAL      MY_RECS(IX).MSYOSYCODE   = REC1.MSYOSYCODE
     C***                   EVAL      MY_RECS(IX).MSYOSYTANK   = REC1.MSYOSYTANK
     C                   ENDDO
     C*
     C                   IF        %ELEM(MY_RECS ) > *ZERO
     C                   EVAL      W#MSG1        = 'MY_RECS(01)'
     C                                         + %CHAR(MY_RECS(01).MSYOSYCODE )
     C                                         + ','
     C                                         + %CHAR(MY_RECS(01).MSYOSYTANK )
     C     W#MSG1        DSPLY
     C                   ENDIF
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @LEAVESR    ＬＥＡＶＥＳＲ                               **
     C*-***************************************************************
     C     @LEAVESR      BEGSR
     C*
     C*■ＧＯＴＯ～ＴＡＧより、ルーチンを終了するという明確なジャンプができる
     C*  一方向ジャンプのためＴＡＧ間違いの永久ループ処理とならない
     C                   SETOFF                                       30
     C                   SETOFF                                       404142
     C                   EVAL      *INKC         = *OFF
     C                   EVAL      *INKD         = *OFF
     C                   EVAL      *INKJ         = *OFF
     C*
     C                   EVAL      W#TANKBN      = 'ZZ'                         単価区分
     C*
     C*---------------------
     C*Ｆ０４）検索処理
     C*---------------------
     C                   IF        *INKD
     C*                  EXSR      @SLT1
     C                   LEAVESR
     C                   ENDIF
     C*
     C*---------------------
     C*Ｆ１０）確定処理
     C*---------------------
     C                   IF        *INKJ
     C*                  EXSR      @CHK1
     C   30              LEAVESR
     C                   SETOFF                                       43
     C*  更新処理→画面２セットへ
     C*                  EXSR      @UPD2
     C*                  EXSR      @DSP2
     C                   LEAVESR
     C                   ENDIF
     C*
     C*---------------------
     C*Ｆ０３）終了処理
     C*---------------------
     C*終了以外はジャンプ
     C                   IF        NOT *INKC
     C                   LEAVESR
     C                   ENDIF
     C*
     C*＊ＩＮ４０＝ＯＮ…更新なしはジャンプ
     C                   IF        *IN40
     C                   LEAVESR
     C                   ENDIF
     C*
     C*参照不可はジャンプ
     C     MSYOL01_KEY1  CHAIN     MSYOR
     C                   IF        NOT %FOUND
     C                   LEAVESR
     C                   ENDIF
     C*
     C*指定単価区分は何もせず終了
     C                   IF        W#TANKBN      = 'BB'      OR
     C                             W#TANKBN      = 'BC'      OR
     C                             W#TANKBN      = 'BD'      OR
     C                             W#TANKBN      = 'CB'      OR
     C                             W#TANKBN      = 'CC'      OR
     C                             W#TANKBN      = 'CD'
     C*                  UNLOCK    MSYOL01@4
     C                   LEAVESR
     C                   ENDIF
     C*
     C*上記以外単価区分は更新処理を実行
     C*                  EXSR      @UPD1
     C*                  EXSR      @UPD2
     C*
     C*/////////////////////
     C*■注意
     C*/////////////////////
     C*  ＤＯを使っていると”ＬＥＡＶＥ”と間違えやすいため注意
     C*    ＥＮＤＤＯ以後の期待する処理がされない
     C                   DOU       1           = 1
     C                   EVAL      W#MSG1        = 'ここは通る'
     C     W#MSG1        DSPLY
     C                   LEAVESR
     C*    本当はＬＥＡＶＥ
     C                   LEAVE
     C                   ENDDO
     C*
     C                   EVAL      W#MSG1        = 'ここは通らない'
     C     W#MSG1        DSPLY
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @ELSEIF     ＥＬＳＥＩＦ                                 **
     C*-***************************************************************
     C     @ELSEIF       BEGSR
     C*
     C                   EVAL      W#TANKBN      = 'CB'                         単価区分
     C                   EVAL      W#NEBIKI      = *ZERO                        値引率％
     C*
     C*■一つのＥＮＤＩＦなので「何れか」のみが適用されるのが明確となる
     C*    値引率…１０％
     C                   IF        W#TANKBN      = 'AA'
     C                   EVAL      W#NEBIKI      = 10                           値引率％
     C*    値引率…２０％
     C                   ELSEIF    W#TANKBN      = 'BB'      OR
     C                             W#TANKBN      = 'BC'      OR
     C                             W#TANKBN      = 'BD'      OR
     C                             W#TANKBN      = 'CB'      OR
     C                             W#TANKBN      = 'CC'      OR
     C                             W#TANKBN      = 'CD'
     C                   EVAL      W#NEBIKI      = 20                           値引率％
     C*    値引率…３０％
     C                   ELSEIF    W#TANKBN      = 'DB'
     C                   EVAL      W#NEBIKI      = 30                           値引率％
     C                   ENDIF
     C*
     C                   EVAL      W#MSG1        = '値引率＝'
     C                                           + %CHAR(W#NEBIKI  )
     C                                           + '％'
     C     W#MSG1        DSPLY
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @SELECT     ＳＥＬＥＣＴ                                 **
     C*-***************************************************************
     C     @SELECT       BEGSR
     C*
     C                   EVAL      W#TANKBN      = 'DB'                         単価区分
     C                   EVAL      W#NEBIKI      = *ZERO                        値引率％
     C*
     C*■比較対象が同じ場合は「ＷＨＥＮ－ＩＳ，ＩＮ」でシンプルに記述できる
     C*    ＷＨＥＮ－ＩＳ…一致する
     C*    ＷＨＥＮ－ＩＮ…含む
     C*  ※注意）Ｖ７Ｒ４以降でＰＴＦ必要な場合あり
     C                   SELECT    W#TANKBN
     C*    値引率…１０％
     C                   WHEN-IS   'AA'
     C                   EVAL      W#NEBIKI      = 10                           値引率％
     C*    値引率…２０％
     C                   WHEN-IN   %LIST('BB' :'BC' :'BD'
     C                                  :'CB' :'CC' :'CD' )
     C                   EVAL      W#NEBIKI      = 20                           値引率％
     C*    値引率…３０％
     C                   WHEN-IS   'DB'
     C                   EVAL      W#NEBIKI      = 30                           値引率％
     C                   ENDSL
     C*
     C                   EVAL      W#MSG1        = '値引率＝'
     C                                           + %CHAR(W#NEBIKI  )
     C                                           + '％'
     C     W#MSG1        DSPLY
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @FOR_EACH   ＦＯＲ　ＥＡＣＨ                             **
     C*-***************************************************************
     C     @FOR_EACH     BEGSR
     C*
     C*■ＦＯＲ－ＥＡＣＨは、全ての要素を取得できるため
     C*    参照の繰り返しにはとても便利
     C*  ※注意）但し要素の値の設定には使えない
     C                   FOR-EACH  W#REC        IN MY_RECS
     C                   EVAL      W#MSG1        = 'W#REC…'
     C                                         + %CHAR(W#REC.MSYOSYCODE )
     C                                         + ','
     C                                         + %CHAR(W#REC.MSYOSYTANK )
     C     W#MSG1        DSPLY
     C                   LEAVE
     C                   ENDFOR
     C*
     C                   ENDSR
     C*-***************************************************************
     C*-* @NOT        ＮＯＴ                                       **
     C*-***************************************************************
     C     @NOT          BEGSR
     C*
     C*■ＮＯＴ（否定）を上手に使い見やすいコーディングをする
     C     MSYOL01_KEY1  CHAIN     MSYOR
     C                   IF        NOT %FOUND
     C                   EVAL      W#MSG1        = '参照できなかった'
     C     W#MSG1        DSPLY
     C                   ENDIF
     C*
     C                   EVAL      W#TANKBN      = 'XX'                         単価区分
     C                   IF        NOT (
     C                               W#TANKBN      = 'AA'      OR
     C                               W#TANKBN      = 'BB'      OR
     C                               W#TANKBN      = 'BC'      OR
     C                               W#TANKBN      = 'BD'      OR
     C                               W#TANKBN      = 'CB'      OR
     C                               W#TANKBN      = 'CC'      OR
     C                               W#TANKBN      = 'CD'
     C                             )
     C                   EVAL      W#MSG1        = '候補に含まない'
     C     W#MSG1        DSPLY
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
