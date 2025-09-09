#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

#DEFINE VBOX      012
#DEFINE HMARGEM   010
#DEFINE VMARGEM   010
#DEFINE cEnt CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHTKETQ    บAutor  ณLeandro Carvalho    บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Imprime Etiquetas das Caixas                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



*----------------------------------------------------------------------------------------------*
User Function JOBETQ ()
*----------------------------------------------------------------------------------------------*
* IMPRESSAO EM ETIQUETA A PARTIR DO SERVIDOR  
*----------------------------------------------------------------------------------------------*


	Local  odlgetq
	Local  cPRODUTO       := SPACE(6)
	Private ofontA32   :=tfont():new("Arial",,-32,,.T.)
	Private cAcesso    := Repl(" ",10)

    u_cf_logusr(ProcName())

	DEFINE MSDIALOG odlgetq TITLE "PRODUTO"  FROM 0,0 to 200,850   PIXEL


	@ 030  , 010  Say    "COD PRODUTO"          SIZE  150,025   OF  odlgetq                            PIXEL   FONT  ofontA32   Colors   Rgb ( 0,0,155)
	@ 030  , 160  MSGET   cPRODUTO              SIZE  100 ,025   OF  odlgetq    Picture "@ XX9999"   PIXEL   FONT  ofontA32

              

	TButton():New( 070,270,'ok',odlgetq ,{||   odlgetq:End()  }  ,60  ,30, ,ofontA32,,.T.)

	ACTIVATE MSDIALOG odlgetq  CENTERED


	IF !EMPTY( ALLTRIM( cPRODUTO   ))

		Impbarras (cPRODUTO  )
   
	Endif



Return




*----------------------------------------------------------------------------------------------*
Static Function Impbarras( cPRODUTO  )
*----------------------------------------------------------------------------------------------*
* IMpressao de pedido em pdf
*----------------------------------------------------------------------------------------------*
	Local 	lAdjustToLegacy := .F.
	Local 	lDisableSetup   := .T.   // desabilita o setup para setar os parametros
	Local 	cLocal          := "\spool\"  // manten no spol para o sistema gerar o binario no server porque se nao demora muito
	Local   cFilePrintert   := "opccod.rel"
	Local   atam
	Local   afix
	Local   apos
	Local   aorienta          := {}
	Local   lexibe            := .T.





*----------------------------------------------------------------*
* VArivaveis para impressao do relatorio
*----------------------------------------------------------------*

	Private oPrinter
	Private oFont12n          := TFont():New('Arial',,-12,.T.)
	Private oFont12b          := TFont():New('Arial Black',,-12,.T.)
	Private oFont16n          := TFont():New('Arial',,-16,.T.)
	Private oFont16b          := TFont():New('Arial Black',,-16,.T.)
	Private oFont18n          := TFont():New('Arial',,-18,.T.)
	Private oFont24n          := TFont():New('Arial',,-24,.T.)
	Private oFont28n          := TFont():New('Arial',,-28,.T.)
	Private oFont36n          := TFont():New('Arial',,-36,.T.)
	Private nmargtop
	Private nmargbot
	Private nmargleft
	Private nmargright
	Private nvpage
	Private nhpage
	Private norienta
	Private nlin
	Private npag           := 1
	Private ntotpag
	Private aCaixa         := {}


*-----------------------------------------------
* Come็o do relatorio
*-----------------------------------------------
	oPrinter := FWMSPrinter():New(cFilePrintert , IMP_PDF , lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrinter:SetResolution(72)               // Atualmente a versใo da Totvsprinter somente trabalha com o valor fixo de 72. Portanto nใo deve setar outro valor.
	oPrinter:SetPortrait()                   // default do realatori9o
	oPrinter:SetPaperSize(9)
	oPrinter:SetMargin(HMARGEM,VMARGEM,(2 * HMARGEM),( 2 * VMARGEM))             // nEsquerda, nSuperior, nDireita, nInferior

	oPrinter:CPATHPDF      := "C:\haytek\zrelpdf\"                  // nao esta adiantando inicializar anntes

	carquivo  := "C:\haytek\zrelpdf\opccod.pdf"

	if file ( carquivo )
		ferase( carquivo  )
	Endif

	IF  lexibe
	
		oPrinter:Setup()
	
	Endif

	MAKEDIR ( "C:\haytek\" )
	MAKEDIR ( "C:\haytek\zrelpdf\" )
	oPrinter:CPATHPDF      := "C:\haytek\zrelpdf\"                 //  forca apos o setup a altera็ใo do diretorio

	w_tux := 0

	u_htk_proc ( {|| Monta_imp( cPRODUTO  )  } )

Return


*-----------------------------------*
Static Function Monta_imp (cPRODUTO  )
*-----------------------------------*
* incio da execu็ใo do relatorio
*-----------------------------------*


*-----------------------------------------------
* Come็o do relatorio
*-----------------------------------------------
	U_Htk_Var()    // carrega as variaveis de controle e start page


	cQuery := "  SELECT   *  "+cEnt
	cQuery += "	 FROM (   "+cEnt
	cQuery += " sELECT   SUBSTRING(  B1_XMEDIDA , 1  , 11 )  AS DIAMETRO  ,  "+cEnt
	cQuery += "		  B1_XESFERI  ,CONVERT (INTEGER , ABS( B1_XCILIND )) as cilind  , "+cEnt
	cQuery += "          MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND  ) * 100 ))  % 100   = 0 THEN SUBSTRING(  B1_XMEDIDA , 12  , 30 )  ELSE '' END  )   '_000' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND  ) * 100 ))  % 100   = 0 THEN  B1_XOPCCOD  ELSE '' END  )   'O000' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 25 THEN SUBSTRING(  B1_XMEDIDA , 12  , 30 )  ELSE '' END  )  '_025' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 25 THEN B1_XOPCCOD   ELSE '' END  )  'O025' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 50 THEN SUBSTRING(  B1_XMEDIDA , 12  , 30 )  ELSE '' END  )  '_050' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 50 THEN B1_XOPCCOD    ELSE '' END  )  'O050' , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 75 THEN SUBSTRING(  B1_XMEDIDA , 12  , 30 )  ELSE '' END  )  '_075'  , "+cEnt
	cQuery += "		  MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XCILIND ) * 100 ))  % 100   = 75 THEN B1_XOPCCOD    ELSE '' END  )  'O075' "+cEnt
	cQuery += " FROM   SB1010 "+cEnt
	cQuery += " WHERE B1_BASE    = '"+cPRODUTO+"'   "+cEnt
	cQuery += "       AND     SUBSTRING(B1_BASE , 1 , 2 )  = 'FS'  "+cEnt
	cQuery += " AND   B1_XOPCCOD <> 'AGRUPADO'  "+cEnt
	cQuery += " AND   D_E_L_E_T_  = ' '  "+cEnt
	cQuery += " GROUP BY   SUBSTRING(  B1_XMEDIDA , 1  , 11 )  , B1_XESFERI  ,  CONVERT (INTEGER , ABS( B1_XCILIND ))   "+cEnt
	cQuery += " UNION  ALL  "+cEnt
	cQuery += " sELECT   B1_XOLHO    AS DIAMETRO  ,  "+cEnt
	cQuery += "  	  B1_XESFERI  , CONVERT (INTEGER , ABS( B1_XADICAO ) + 0.01 ) as cilind  ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 0 THEN  B1_XOLHO + '-'+SUBSTRING(  B1_XMEDIDA , 15 , 30 )  ELSE '' END  )   '_000' ,  "+cEnt
	cQuery += "        MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 0 THEN  B1_XOPCCOD  ELSE '' END  )   'O000' ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 25 THEN B1_XOLHO + '-'+SUBSTRING(  B1_XMEDIDA , 15  , 30 )  ELSE '' END  )  '_025' ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 25 THEN B1_XOPCCOD   ELSE '' END  )  'O025' ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 50 THEN B1_XOLHO + '-'+SUBSTRING(  B1_XMEDIDA , 15  , 30 )  ELSE '' END  )  '_050' ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 50 THEN B1_XOPCCOD    ELSE '' END  )  'O050' ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 75 THEN B1_XOLHO + '-'+SUBSTRING(  B1_XMEDIDA , 15  , 30 )  ELSE '' END  )  '_075'  ,  "+cEnt
	cQuery += "       MAX ( CASE   WHEN  CONVERT (  INTEGER ,  ( ABS(  B1_XADICAO  ) * 100 ))  % 100   = 75 THEN B1_XOPCCOD    ELSE '' END  )  'O075' "+cEnt
	cQuery += "       FROM   SB1010  "+cEnt
	cQuery += "       WHERE B1_BASE   = '"+cPRODUTO+"'   "+cEnt
	cQuery += "       AND   B1_XOPCCOD <> 'AGRUPADO'   "+cEnt
	cQuery += "       AND     SUBSTRING(B1_BASE , 1 , 2 )  = 'FP'  "+cEnt
	cQuery += "       AND   D_E_L_E_T_  = ' ' "+cEnt
	cQuery += "       GROUP BY   B1_XOLHO   , B1_XESFERI  ,  CONVERT (INTEGER , ABS( B1_XADICAO )+0.01 )     ) AS TOTAL "+cEnt
	cQuery += "       ORDER BY  1   ,  3   ,  2   "+cEnt


 




	oPrinter:SayAlign ( nmargtop + 5  , 020       , "Opccode " + cPRODUTO  , oFont12b ,500  ,  030   , 0  , 2 , 0  )

 


	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "OPCCOD", .F., .T.)
	DbSelectArea( "OPCCOD")


	nflin  := 45
	IF !EOF()
		WHILE !EOF()


			cmeddias   :=  OPCCOD->DIAMETRO  + str(cilind, 5 )

			WHILE !EOF() .and.  cmeddias   =   OPCCOD->DIAMETRO  + str(cilind, 5 )
    
	
				nimplin   :=  nflin
				nflin    += 30
	
	
	//oPrinter:Box      (    nimplin    , 10   ,  nflin     ,  nHPage  ,"-2")
	
				IF !Empty ( OPCCOD->_000 )
		
					oPrinter:SayAlign (    nimplin + 2  , 10 ,   OPCCOD->_000  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
		//oPrinter:SayAlign (    nimplin + 15 , 15 ,   ALLTRIM(OPCCOD->O000)  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
					cbarras   :=      U_Cod_int25( ALLTRIM(OPCCOD->O000)  , .F. )
					Mot_Bar   (       nimplin + 15  ,  30  ,  cbarras )
	
				endif
	
				IF !Empty ( OPCCOD->_025 )
	
					oPrinter:SayAlign (    nimplin + 2  , 160 ,   OPCCOD->_025  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
		//oPrinter:SayAlign (    nimplin + 15 , 165 ,   ALLTRIM(OPCCOD->O025) , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
					cbarras   :=      U_Cod_int25( ALLTRIM(OPCCOD->O025)  , .F. )
					Mot_Bar   (       nimplin + 15  ,  180  ,  cbarras )
		
				endif
		
		
				IF !Empty ( OPCCOD->_050 )
	
					oPrinter:SayAlign (    nimplin + 2 , 310 ,   OPCCOD->_050  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
		//oPrinter:SayAlign (    nimplin + 15 , 315 ,   ALLTRIM(OPCCOD->O050)  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
					cbarras   :=      U_Cod_int25( ALLTRIM(OPCCOD->O050)  , .F. )
					Mot_Bar   (       nimplin + 15  ,  330  ,  cbarras )
	
				Endif
	
	
				IF !Empty ( OPCCOD->_075)
	
	
					oPrinter:SayAlign (    nimplin + 2 , 460 ,   OPCCOD->_075  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
		//oPrinter:SayAlign (    nimplin + 15 , 465 ,   ALLTRIM(OPCCOD->O075)  , oFont12b , 130 ,  30  , 0 ,  0 , 1   )
					cbarras   :=      U_Cod_int25( ALLTRIM(OPCCOD->O075)  , .F. )
					Mot_Bar   (       nimplin + 15  ,  480  ,  cbarras )
	
	
				Endif
	
				DbSelectArea( "OPCCOD")
				DbSkip()
			Enddo
	

		
			oPrinter:EndPage()
			oPrinter:Startpage()  // inicializa outra
			nflin :=  45
	 
		
	

		Enddo
	


	ELSE

		U_AVISO("NAO A OPCEODE PARA O PRODUTO DIGITADO" )
 
	Endif

	DbSelectArea( "OPCCOD")
	DbClosearea()
	
	
	oPrinter:EndPage()


  
	If  oPrinter:nModalResult == PD_OK
		oPrinter:Preview()
	Else
		oPrinter:Print()
	EndIf
	



	
Return




*-------------------------------------------------------------------------------------------------*
STATIC Function Mot_Bar( nrow , ncol  ,  cConteudo ,  nIniVertical )
*-------------------------------------------------------------------------------------------------*

	Local n
	Local oBr  :=  TBrush():New( , 0     )
	Local ac   :=  array(4)
	Local nHeigth
	Local nWidth


	nWidth  := 1
	nHeigth := 10


	For n:=1 to len(cConteudo)
		If substr(cConteudo,n,1) =='1'
		
			ac[1]:= nRow
			ac[2]:= nCol
			ac[3]:= nRow+nHeigth
			ac[4]:= nCol+nWidth
			nCol+=nWidth
		
		
			oPrinter:fillRect(ac,oBr)
		
		
		
		Else
		
			nCol+=nWidth
		
		End
	
	Next

	oBr:end()


Return





*----------------------------------------------------------------------------------------------------------------------------*
user Function  Cod_int25( ccod  , lCheck )
*----------------------------------------------------------------------------------------------------------------------------*
* Montagem do codigo  auxilar binario para listar lista grossa e lista branca
*----------------------------------------------------------------------------------------------------------------------------*

Local cBarra    := ""
Local cConteudo := ""
Local cParte1	 := ""
Local cParte2	 := ""
Local nLen		 := 0
Local nCheck    := 0
Local nX,nY
Local aBar := {'00110','10001','01001','11000','00101','10100','01100','00011','10010','01010'}
Local cCode:=trans(ccod ,'@9') // elimina caracteres
Default lCheck   := .F.



If (nLen%2==1 .and. !lCheck)
	nLen++
	cCode+='0'
End

If lCheck

	For nX:=1 to len(cCode) step 2

		nCheck+=val(substr(cCode,nX,1))*3+val(substr(cCode,nX+1,1))

	Next

	cCode += right(str(nCheck,10,0),1)

End

nLen:=len(cCode)

cBarra:= '0000'

For nX:=1 to nLen step 2
	
	cParte1 := aBar[val(substr(cCode,nX,1))+1]
	cParte2 := aBar[val(substr(cCode,nX+1,1))+1]
	
	For nY:=1 to 5
		cBarra += substr(cParte1,nY,1)+substr(cParte2,nY,1)
	Next

Next

cBarra+= '100'

For nX:=1 to len(cBarra) step 2

	cConteudo += If(Subs(cBarra,nX  ,1)=='1','11','1')        //    1  lista preta fina   111 lista preta grossa
	cConteudo += If(Subs(cBarra,nX+1,1)=='1','00','0')        //    0 lista branca fina   000 lista branca grossa

Next


Return cConteudo

