

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSCEP      บAutor  ณLeandro Carvalho    บ Data ณ  05/12/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------*
User Function WSCEP(  ccep  )
*---------------------------------------------------------*
* Busca o endereceo a partir do cep 
*---------------------------------------------------------*

Local csoap       := ""
Local cSoapAction := ""
Local cSoapStyle  := "DOCUMENT"
Local cOperation  := "consultaCEP"  
Local cSoapHead   := ""
Local csoap       := ""
Local aEtiqueta   := {}
Local aRetorno    := {} 
Local netq  
Local cdig        
Local cPostUrl     := "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"  
Local cuf          := ""
Local ccidade     := ""
Local cbairro     := ""
Local cend        := ""
Local ccomple    := ""

Local nPrim     := 0
Local nUlti     := 0      
       

u_cf_logusr(ProcName())

csoap += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">'
csoap += '<soapenv:Header/>'
csoap += '<soapenv:Body>'
csoap += '<cli:consultaCEP>'
csoap += '<cep>'+ccep +'</cep>'
csoap += '</cli:consultaCEP>'
csoap += '</soapenv:Body>'
csoap += '</soapenv:Envelope>'




cnovosoap  := strtran ( cSoap  , "><" , ">"+chr(13)+Chr(10)+"<" )
MEMOWRITE ( "C:\haytek\xmlrelatorios\conscep.txt" , cnovosoap )


oXmlRet := u_Soap_Call(  cPostUrl  ,  cSoap , cSoapAction , cSoapStyle ,cOperation  , "Correios Cep  "    , .T. )



w_tux := 0     // oXmlRet

IF  Type ("oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_BAIRRO:TEXT")   = 'C' 
    
    cUF       := u_noacento (Upper( oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_UF:TEXT )           )
    cCidade   := u_noacento (Upper( oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_CIDADE:TEXT )       )
    cbairro   := u_noacento (Upper( oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_BAIRRO:TEXT )       )
    cend      := u_noacento (Upper( oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_END:TEXT )          )
    if  Type ("oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_COMPLEMENTO:TEXT")   = 'C'    
       ccomple   := u_noacento (Upper( oXmlRet:_NS2_CONSULTACEPRESPONSE:_RETURN:_COMPLEMENTO:TEXT )  )
	else
	    ccomple   := ""  
    endif 	    

	
	if ccep = '14110000'
		cCidade:= 'RIBEIRAO PRETO'
	
	elseif ccep = '45936000'
		cCidade:= 'MUCURI'
	
	// Leonardo Paiva - 03/07/2019
	// Na consulta desse CEP estแ trazendo uma descri็ใo diferente do municipio
		
    elseif ccep = '45928000'  
        cCidade:= 'NOVA VICOSA'
        
    ElseIf At( '(', cCidade) > 0
    
        // Leonardo Paiva - 09/07/2019  
        // Tratamento para os endere็os que mandam 
        // o bairro junto com a cidade, separados por par๊ntes '('  
         
       // Pega a posi็ใo do primeiro par๊ntese 
       nPrim := At('(' , cCidade)
       
       // Pega a posi็ใo do ๚ltimo par๊ntese       
       nUlti := At(')' , cCidade)      
       
       cbairro := Substr( cCidade, 1, nPrim -1)
       
       cCidade := Substr( cCidade, nPrim + 1, (nUlti - nPrim)-1)
    
    
	endif
	
	
	
  
   aadd (   aRetorno   ,  cUF        ) 
   aadd (   aRetorno   ,  cCidade    )
   aadd (   aRetorno   ,  cbairro    )
   aadd (   aRetorno   , cend        )
   aadd (   aRetorno   , ccomple     )  
    
Endif 


Return  aRetorno

