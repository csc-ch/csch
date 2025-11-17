     H**********************************************************************
     H*                                                                    *
     H*   システム名      :ＲＰＧ教育                                *
     H*   サブシステム名  :ＩＢＭリスキリング・カレッジ              *
     H*   プログラム名    : #03 Ｉ仕様書の呪縛（固定                 *
     H*   プログラムＩＤ  : GOD031R@41                                 *
     H*   会　社　名　　  :株式会社中部システム                      *
     H*                                                                    *
     H*     作　成　者    :㈱中部システム Y.USHIDA                   *
     H*     作　成　日    : 2025/09/05                                 *
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
     F*売上データ
     FSUR1P     IF   E           K DISK
     F*売上実績集計ファイル
     FSUR2P     UF A E           K DISK
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
     D*-********************************************************************
     D*-* 変数定義                                                      **
     D*-********************************************************************
     D  WTIMESTAMP     S             26Z                                        タイムスタンプ
     D  WDATE8         S              8S 0                                      日付
     D  WTIME6         S              6S 0                                      時刻
     D*
     D*-------------------------------------------------------------------------
     D*■ネストさせて階層を見やすくすることができる
     D*-------------------------------------------------------------------------
     D*■ＦＲＯＭ～ＴＯを記述しないで配列とフィールドをオーバーレイ
     D*  １）ＤＡＴＳ…………ＤＳ上のオーバーレイ起点名（単なる文字列扱い
     D*  ２）ＯＶＥＲＬＡＹ…起点に対して”変数”を重ねる（オーバーレイ）
     D*  ３）＊ＮＥＸＴ………次のオーバーレイは前の直後から重ねる
     D*  ４）ＡＲＹＳ…………起点に対して配列を重ねる
     D*-------------------------------------------------------------------------
     D*      数量配列                  数量フィールド
     D*  ５）ＡＲＹＳ（０１）～（３１）＝Ｓ２ＳＵ０１～Ｓ２ＳＵ３１
     D*-------------------------------------------------------------------------
     D*数量（０１～３１
     D                 DS
     D DATS
     D  S2SU01                             OVERLAY(DATS        )
     D  S2SU02                             OVERLAY(DATS :*NEXT )
     D  S2SU03                             OVERLAY(DATS :*NEXT )
     D  S2SU04                             OVERLAY(DATS :*NEXT )
     D  S2SU05                             OVERLAY(DATS :*NEXT )
     D  S2SU06                             OVERLAY(DATS :*NEXT )
     D  S2SU07                             OVERLAY(DATS :*NEXT )
     D  S2SU08                             OVERLAY(DATS :*NEXT )
     D  S2SU09                             OVERLAY(DATS :*NEXT )
     D  S2SU10                             OVERLAY(DATS :*NEXT )
     D  S2SU11                             OVERLAY(DATS :*NEXT )
     D  S2SU12                             OVERLAY(DATS :*NEXT )
     D  S2SU13                             OVERLAY(DATS :*NEXT )
     D  S2SU14                             OVERLAY(DATS :*NEXT )
     D  S2SU15                             OVERLAY(DATS :*NEXT )
     D  S2SU16                             OVERLAY(DATS :*NEXT )
     D  S2SU17                             OVERLAY(DATS :*NEXT )
     D  S2SU18                             OVERLAY(DATS :*NEXT )
     D  S2SU19                             OVERLAY(DATS :*NEXT )
     D  S2SU20                             OVERLAY(DATS :*NEXT )
     D  S2SU21                             OVERLAY(DATS :*NEXT )
     D  S2SU22                             OVERLAY(DATS :*NEXT )
     D  S2SU23                             OVERLAY(DATS :*NEXT )
     D  S2SU24                             OVERLAY(DATS :*NEXT )
     D  S2SU25                             OVERLAY(DATS :*NEXT )
     D  S2SU26                             OVERLAY(DATS :*NEXT )
     D  S2SU27                             OVERLAY(DATS :*NEXT )
     D  S2SU28                             OVERLAY(DATS :*NEXT )
     D  S2SU29                             OVERLAY(DATS :*NEXT )
     D  S2SU30                             OVERLAY(DATS :*NEXT )
     D  S2SU31                             OVERLAY(DATS :*NEXT )
     D ARYS                                LIKE(S2SU01  )
     D                                     DIM(31)
     D                                     OVERLAY(DATS : 1    )
     D*
     D*金額（０１～３１
     D                 DS
     D DATK
     D  S2KN01                             OVERLAY(DATK        )
     D  S2KN02                             OVERLAY(DATK :*NEXT )
     D  S2KN03                             OVERLAY(DATK :*NEXT )
     D  S2KN04                             OVERLAY(DATK :*NEXT )
     D  S2KN05                             OVERLAY(DATK :*NEXT )
     D  S2KN06                             OVERLAY(DATK :*NEXT )
     D  S2KN07                             OVERLAY(DATK :*NEXT )
     D  S2KN08                             OVERLAY(DATK :*NEXT )
     D  S2KN09                             OVERLAY(DATK :*NEXT )
     D  S2KN10                             OVERLAY(DATK :*NEXT )
     D  S2KN11                             OVERLAY(DATK :*NEXT )
     D  S2KN12                             OVERLAY(DATK :*NEXT )
     D  S2KN13                             OVERLAY(DATK :*NEXT )
     D  S2KN14                             OVERLAY(DATK :*NEXT )
     D  S2KN15                             OVERLAY(DATK :*NEXT )
     D  S2KN16                             OVERLAY(DATK :*NEXT )
     D  S2KN17                             OVERLAY(DATK :*NEXT )
     D  S2KN18                             OVERLAY(DATK :*NEXT )
     D  S2KN19                             OVERLAY(DATK :*NEXT )
     D  S2KN20                             OVERLAY(DATK :*NEXT )
     D  S2KN21                             OVERLAY(DATK :*NEXT )
     D  S2KN22                             OVERLAY(DATK :*NEXT )
     D  S2KN23                             OVERLAY(DATK :*NEXT )
     D  S2KN24                             OVERLAY(DATK :*NEXT )
     D  S2KN25                             OVERLAY(DATK :*NEXT )
     D  S2KN26                             OVERLAY(DATK :*NEXT )
     D  S2KN27                             OVERLAY(DATK :*NEXT )
     D  S2KN28                             OVERLAY(DATK :*NEXT )
     D  S2KN29                             OVERLAY(DATK :*NEXT )
     D  S2KN30                             OVERLAY(DATK :*NEXT )
     D  S2KN31                             OVERLAY(DATK :*NEXT )
     D ARYK                                LIKE(S2KN01  )
     D                                     DIM(%ELEM(ARYS ))
     D                                     OVERLAY(DATK : 1    )
     C*-********************************************************************
     C*-* ＫＬＩＳＴ                                                    **
     C*-********************************************************************
     C     SU2KEY        KLIST
     C                   KFLD                    S2YM01
     C                   KFLD                    S2SYHN
     C*-********************************************************************
     C*-* メインルーチン                                                **
     C*-********************************************************************
     C*初期処理
     C                   EXSR      @INZ
     C*
     C                   DOU       %EOF(SUR1P      )
     C                   READ      SUR1R
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      @UPD
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
     C                   ENDSR
     C*-***************************************************************
     C*-* @UPD        集計処理                                     **
     C*-***************************************************************
     C     @UPD          BEGSR
     C*
     C                   MOVEL     S1DT01        S2YM01
     C                   MOVEL(P)  S1SYHN        S2SYHN
     C     SU2KEY        CHAIN     SUR2R                              50
     C   50              CLEAR                   SUR2R
     C*
     C                   MOVEL     S1DT01        S2YM01
     C                   MOVEL(P)  S1SYHN        S2SYHN
     C*
     C                   Z-ADD     S1DT01        I                 2 0
     C                   ADD       S1SU01        ARYS(I)
     C                   ADD       S1KN01        ARYK(I)
     C*
     C                   Z-ADD     WDATE8        S2UPDT
     C                   Z-ADD     WTIME6        S2UPTM
     C                   MOVEL(P)  S#PROC        S2UPPG
     C*
     C   50              WRITE     SUR2R
     C  N50              UPDATE    SUR2R
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
