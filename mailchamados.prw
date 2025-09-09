#INCLUDE "Protheus.ch"    
#include "TOTVS.CH"
#DEFINE cEnt CHR(13)+CHR(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmailChamadoบ Autor ณ  Matheus           บ Data ณ  21/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   E-mail diแrio dos chamados e pendencias de t.i		        บฑฑ
ฑฑบ          ณ                        							            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------------------------------------------------------*
User Function mail_Chamado()
*--------------------------------------------------------------------------------------*
* Envia email dos chamados
*--------------------------------------------------------------------------------------*
Local amailarq  := {}
Local cSubject  := "Email de pendencias TI Haytek "
Local ctexto

RPCSetType ( 3 )
U_RpcSethtk(U_GetEmpAnt(),U_GetFilAnt(),           ,            , 'EST'     ,  'RPC'      , {'SA1'}    )

u_cf_logusr(ProcName())

private aChamados:={}
private aChamados:={}
private cdata:= date()
private cini:=FirstDate(cdata)
private cfim:=LastDate(cdata)
private aPends:={}
private aesthr1:={}
private aesthr2:={}
private aesthr3:={}
private aesthr4:={}
private cDiretoria:=""

cSubject += + dToc(cdata)


private cTo := "matheus.ribeiro@haytek.com.br"
cTo += ";leandro.carvalho@haytek.com.br;"
cTo += "phillipe.assis@haytek.com.br;"
cTo += "ronaldo.santana@haytek.com.br"


//private cTo := "ronaldo.santana@haytek.com.br; ronaldo.kamus@gmail.com;"

RPCSetType ( 3 )   // FAZ CONEXAO COM O PROTHEUS SEM CONSUMIR LICENCA
Connect(,.t.)

		AADD ( aChamados , { '<b><strong>Data</strong></b>' , ;
		'<b><strong>Analista</strong></b>' , ;
		'<b><strong>Chamado</strong></b>' , ;
		'<b><strong>Tempo Gasto</strong></b>'})
		
		AADD ( apends , {'<b><strong>Codigo</strong></b>' , ; 
			'<b><strong>Previsao</strong></b>' , ;
		'<b><strong>Entrega</strong></b>'  , ;
		'<b><strong>Ac. Diretoria</strong></b>'  , ;
		'<b><strong>Analista</strong></b>' , ;
		'<b><strong>Chamado</strong></b>'  , ;
		'<b><strong>Time</strong></b>' , ;
		'<b><strong>Gasto</strong></b>' }) 
		
		/*-----------------------------------------------------
		MONTAGEM DOS VETORES DAS HORAS APONTADAS MENSALMENTE
		*------------------------------------------------------*/
		
		AADD ( aesthr1 , { '<b><strong>Leandro</strong></b>' , ;
		'<b><strong>SEG</strong></b>'  , ;
		'<b><strong>TER</strong></b>' , ;
		'<b><strong>QUA</strong></b>'  , ;
		'<b><strong>QUI</strong></b>' , ;
		'<b><strong>SEX</strong></b>' })
		
		AADD ( aesthr2 , { '<b><strong>Matheus</strong></b>' , ;
		'<b><strong>SEG</strong></b>'  , ;
		'<b><strong>TER</strong></b>' , ;
		'<b><strong>QUA</strong></b>'  , ;
		'<b><strong>QUI</strong></b>' , ;
		'<b><strong>SEX</strong></b>' }) 
		
		AADD ( aesthr3 , { '<b><strong>Phillipe</strong></b>' , ;
		'<b><strong>SEG</strong></b>'  , ;
		'<b><strong>TER</strong></b>' , ;
		'<b><strong>QUA</strong></b>'  , ;
		'<b><strong>QUI</strong></b>' , ;
		'<b><strong>SEX</strong></b>' }) 
		
		AADD ( aesthr4 , { '<b><strong>Ronaldo</strong></b>' , ;
		'<b><strong>SEG</strong></b>'  , ;
		'<b><strong>TER</strong></b>' , ;
		'<b><strong>QUA</strong></b>'  , ;
		'<b><strong>QUI</strong></b>' , ;
		'<b><strong>SEX</strong></b>' })  
		
		//POPULAR VETOR DO LEANDRO
 		cQuery := "EXEC SPT_HTKTI_AGENDA 'leandro'"  + cEnt
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "HORA", .F., .T.)
		DbSelectArea("HORA")

			While !eof()
			     Aadd ( aesthr1 , { '<b>'+HORA->SEMANA+'</b>'         ,;
			     	 '<b>'+alltrim(Transform(HORA->SEGU  , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->TER   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUA   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUI   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->SEX   , "@E 999.99"))+'</b>' } )
				DbSkip()
			enddo	

		DbSelectArea("HORA")
		Dbclosearea()
		
		//POPULAR VETOR DO MATHEUS
 		cQuery := "EXEC SPT_HTKTI_AGENDA 'matheus'"  + cEnt
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "HORA", .F., .T.)
		DbSelectArea("HORA")

			While !eof()
			     Aadd ( aesthr2 , { '<b>'+HORA->SEMANA+'</b>'         ,;
			     	 '<b>'+alltrim(Transform(HORA->SEGU  , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->TER   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUA   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUI   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->SEX   , "@E 999.99"))+'</b>' } )
				DbSkip()
			enddo	

		DbSelectArea("HORA")
		Dbclosearea()
		
		//POPULAR VETOR DO PHILLIPE
		cQuery := "EXEC SPT_HTKTI_AGENDA 'phillipe'"  + cEnt
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "HORA", .F., .T.)
		DbSelectArea("HORA")

			While !eof()
			     Aadd ( aesthr3 , { '<b>'+HORA->SEMANA+'</b>'         ,;
			     	 '<b>'+alltrim(Transform(HORA->SEGU  , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->TER   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUA   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUI   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->SEX   , "@E 999.99"))+'</b>' } )
				DbSkip()
			enddo	

		DbSelectArea("HORA")
		Dbclosearea()
		
		//POPULAR VETOR DO MATHEUS
 		cQuery := "EXEC SPT_HTKTI_AGENDA 'ronaldo'"  + cEnt
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "HORA", .F., .T.)
		DbSelectArea("HORA")

			While !eof()
			     Aadd ( aesthr4 , { '<b>'+HORA->SEMANA+'</b>'         ,;
			     	 '<b>'+alltrim(Transform(HORA->SEGU  , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->TER   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUA   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->QUI   , "@E 999.99"))+'</b>'  ,;
			     	 '<b>'+alltrim(Transform(HORA->SEX   , "@E 999.99"))+'</b>' } )
				DbSkip()
			enddo	

		DbSelectArea("HORA")
		Dbclosearea()
		
		/*-----------------------------------------------------
		FIM DA MONTAGEM DOS VETORES DAS HORAS 
		*------------------------------------------------------*/
		cQuery := "EXEC SPT_HTK_CHAMADOS "  + cEnt
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "EMAIL", .F., .T.)
		DbSelectArea("EMAIL")

While !eof()
     Aadd ( aChamados , { '<b>'+alltrim(EMAIL->ZZT_DIA+"/"+EMAIL->ZZT_MES+"/"+EMAIL->ZZT_ANO)+'</b>' , ;
     	 '<b>'+alltrim(EMAIL->ZZT_TI)+ '</b>' ,;
     	 '<b>'+alltrim(capital(EMAIL->ZZT_RESUMO))+'</b>' ,;
     	 '<b>'+alltrim(Transform(EMAIL->ZZT_TEMPO   , "@E 999.99"))+'</b>' } )
	DbSkip()
enddo	

DbSelectArea("EMAIL")
Dbclosearea()

*-------------------------------------------------------------------------------------*


cQuery := "EXEC SPT_HTK_CHAMADOS_E_PROJETOS'"+dtos(cini)+"' , '"+dtos(cfim)+"'"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "EMAIL2", .F., .T.)
DbSelectArea("EMAIL2")

While !eof()
			if EMAIL2->ZZP_ENTREG <> ' '
				cdataent:=substr(EMAIL2->ZZP_ENTREG, 7)+"/"+substr(EMAIL2->ZZP_ENTREG, 5, 2)+"/"+substr(EMAIL2->ZZP_ENTREG, 1 ,4)
			else
				cdataent:=""
			endif
			
			if EMAIL2->ZZP_PREVIS <> ' '	
				cdatapre:=substr(EMAIL2->ZZP_PREVIS, 7)+"/"+substr(EMAIL2->ZZP_PREVIS, 5, 2)+"/"+substr(EMAIL2->ZZP_PREVIS, 1 ,4)
			else
				cdatapre:=""
			endif
			
			if EMAIL2->ZZP_REAL <> ' '	
				cdiretoria := "S"
			else
				cdiretoria := "N"
			endif
			
     Aadd ( apends , { '<b>'+alltrim(EMAIL2->ZZP_COD)+'</b>' , ;
     	 '<b>'+alltrim(cdatapre)+'</b>' , ;
     	 '<b>'+alltrim(cdataent)+ '</b>' ,;
     	 '<b>'+alltrim(cdiretoria)+ '</b>' ,;
     	 '<b>'+alltrim(EMAIL2->ZZP_TI)+ '</b>' ,;
     	 '<b>'+alltrim(capital(EMAIL2->ZZP_RESUMO))+'</b>' ,;
     	 '<b>'+alltrim(Transform(EMAIL2->ZZP_TIME   , "@E 999.99"))+'</b>' , ;
     	 '<b>'+alltrim(Transform(EMAIL2->XPERCENT   , "@E 999.99%"))+'</b>' } )
	DbSkip()

enddo	
DbSelectArea("EMAIL2")
Dbclosearea()


ctexto :=  u_Cab_email (  cSubject  , .T. )
ctexto +=  u_Lin_email (  '10'  )
	
ctexto +=  '<tr><td>  <HR style="WIDTH:100%; ALIGN:CENTER; height:2px; border-width:1px; color:gray; background-color:gray;">  </td>  </tr>' + cEnt
ctexto +=  u_Lin_email     (  '10'  )
ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  aesthr1  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()

ctexto +=  u_Lin_email     (  '10'  )
ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  aesthr2  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()

ctexto +=  u_Lin_email     (  '10'  )
ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  aesthr3  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()	

ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  aesthr4  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()	

ctexto +=  u_Lin_email     (  '10'  )
ctexto +=  u_Esc_Email     ( '<b>Chamados Rแpidos</b>'          ,   '16'  , 'Left'  )

ctexto +=  u_lin_email     (  '10'  )
ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  aChamados  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()

ctexto +=  u_lin_email     (  '20'  )//termina chamados

ctexto +=  '<tr><td>  <HR style="WIDTH:100%; ALIGN:CENTER; height:2px; border-width:1px; color:gray; background-color:gray;">  </td>  </tr>' + cEnt //divisใo linha

ctexto +=  u_Lin_email     (  '20'  )//come็a projetos
ctexto +=  u_Esc_Email     ( '<b>Projetos</b>'          ,   '16'  , 'Left'  )

ctexto +=  u_lin_email     (  '10'  )
ctexto +=  u_Tabini_email ( "1" )
ctexto +=  u_Tabmeio_Email (  apends  ,   '13'  , 'center' )
ctexto +=  u_tabfim_email()

ctexto +=  u_lin_email     (  '20'  )//termina projetos
ctexto +=  '<tr><td>  <HR style="WIDTH:100%; ALIGN:CENTER; height:2px; border-width:1px; color:gray; background-color:gray">  </td>  </tr>' + cEnt
ctexto +=  u_Rod_email ('src="http://www.haytek.com.br/App_Themes/Sistema/img/roda_pendencia.png">' ,  .T.  , cto , 'PEDIDO' )
	

MemoWrite("C:\haytek\zhtml\TESTE.html",EncodeUTF8 ( ctexto) )
	
lenvia :=  u_Enviamail(  ctexto  , cTo   , csubject  ,  amailarq , .f. , "" ,"pendencia", "Haytek"   )

if !lenvia
		sleep(1000) // Aguarda um segundo para o t้rmino da gera็ใo dos arquivos
		lenvia :=  u_Enviamail(  ctexto  , cTo   , csubject  ,  amailarq , .f. , "" ,"pendencia", "Haytek"   )
		if !lenvia
			sleep(1000) // Aguarda um segundo para o t้rmino da gera็ใo dos arquivos
			lenvia :=  u_Enviamail(  ctexto  , cTo   , csubject  ,  amailarq , .f. , "" ,"pendencia", "Haytek"   )
			IF  !lenvia
				sleep(1000) // Aguarda um segundo para o t้rmino da gera็ใo dos arquivos
			lenvia :=  u_Enviamail(  ctexto  , cTo   , csubject  ,  amailarq , .f. , "" ,"pendencia", "Haytek"   )
				
		Endif
	Endif
Endif
	
	

Return
