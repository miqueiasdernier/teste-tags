#Include 'Protheus.ch'
#DEFINE cEnt CHR(13)+CHR(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±±
±±ºPrograma  ³HTKMUDAZHR ºAutor  ³ Leandro Carvaho    º Data ³ 15/05/17    º±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±
±±ºDesc.     ³ Programa que le o txt gerado pelo dvi para a geração        º±±±
±±º          ³ das informacoes no Protheyus                                º±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±
±±ºUso       ³ totvs 11                                                    º±±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function HTKMUDAZHR()

  

Local     cdiretctory  := "I:\USER\HTK\"
Local     cMascara     := "srvrep*.txt"
Local     carqivotxt
Local     cnomearq     := "" 
Local     nx    
Private   afiles:={} 

u_cf_logusr(ProcName())
    
AEVAL( DIRECTORY( alltrim(cdiretctory)+cMascara), {|aFile| AAdd( aFiles ,  aFile[1] ) } )		// F_NAME = 1

For nx := 1 to len(aFiles)

	carqivotxt  := cdiretctory+afiles[nx]
	cnomearq    := afiles[nx]
	If file (cdiretctory+afiles[nx])
	   carrega_dados(carqivotxt , cnomearq ) 
	
	Endif                              
	
Next



Return  

*------------------------------------------------------------------------------------*
Static Function carrega_dados(carqivotxt , cnomearq  )
*------------------------------------------------------------------------------------*
* Carrega dados do txt    
*------------------------------------------------------------------------------------*

Local aTray    := {} 
Local aLinha   := {}


FT_FUSE( carqivotxt )
FT_FGOTOP()



While !FT_FEOF()
	
	cBuffer := FT_FREADLN()
	cBuffer  += "  |  | " // acrescentando o 11  
	cBuffer  := strtran ( cBuffer , "||" , "| |" )
	alinha   := StrTokArr(cBuffer,"|")    // clinha := "nom2;aaaammdd;123456.99;....  alinha{ xx_campo1, xx_campo2, xx_campo2 , ... }	
	
	
	FT_FSKIP()
     
     aadd ( aTray , aclone( alinha)  ) 
EndDo

FT_FUSE() 
  
  
Ferase( carqivotxt )                   


w_tux  := 0 
Atualiza(aTray , cnomearq ) 


Return      


*------------------------------------------------------------------------------------*
Static Function Atualiza(aTray , cnomearq)
*------------------------------------------------------------------------------------*
* Carrega dados do txt    
*------------------------------------------------------------------------------------*

local ntray 

For ntray   := 1 to len ( aTray ) 


    IF LEN ( aTray[ntray]) >= 11  

	    cquery    := " SPT_HTKMUDAZH_INSERT  '"+aTray[ntray][1]+"'  , " // TRAY
	    cquery    +=  "   '"+aTray[ntray][2]+"'  , "    // CLIENTE 
	    cquery    +=  "   '"+aTray[ntray][3]+"'  , "    // RXNUM  
	    cquery    +=  "   '"+IIF ( Empty ( aTray[ntray][7])  , aTray[ntray][11]  ,aTray[ntray][7] )  +"'  , "        // data 
	    cquery    +=  "   '"+aTray[ntray][10]  +"'  , "        // horas 
	    cquery    +=  "   '"+aTray[ntray][9]  +"'  , "    // ONDE ESTA 
	    cquery    +=  "   '"+cnomearq+"'  "             // NOME ARQUIVO 
	    TcSqlExec(cQuery )
	    w_tux  := 0 
    ENDIF 
	



Next  


Return 



