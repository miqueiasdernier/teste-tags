#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE cEnt CHR(13)+CHR(10)
 
WSRESTFUL HtkDevolucao DESCRIPTION "Devolucao de mercadoria"
  
	// Criacao do Metodos
	WSMETHOD GET DESCRIPTION "Mostra a devolucao" WSSYNTAX "/" PATH "/HtkDevolucao/{cliente}/{OpcCod}/{Quantidade}"
  
END WSRESTFUL
  
// Declaracao dos Metodos
WSMETHOD GET WSSERVICE HtkDevolucao
Local aArea     := GetArea()
Local cAlias    := GetNextAlias()
Local cQuery    := ""
Local cResponse := ""
Local aItem     := {}
Local nPos      := 0

Private cCliente := ""
Private cOpcCod  := ""
Private nQuant   := 0
Private oDev     := JSonObject():New()

If len(self:aURLParms) == 3
    cCliente := self:aURLParms[1]
    cOpcCod	 := self:aURLParms[2]
    nQuant	 := Val(self:aURLParms[3])

Else
   SetRestFault(400, EncodeUTF8("Quantidade de parâmetros invalidos! "))
   Return .F.
EndIf

RPCSetType( 3 )
SetsDefault()
U_RpcSethtk('01', '01', , , 'EST', 'RPC', {'SF2'})

cQuery := "EXEC [SPT_ACHA_DEV] '"+xFilial("SD1")+ "','" + AllTrim(Str(nQuant)) + "', '" + cOpcCod + "','" +cCliente+ "'"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

If (cAlias)->(Eof())
    ::SetResponse(EncodeUTF8("Produto nao encontrado"))
Else
    While !(cAlias)->(Eof()) 
        Aadd(aItem,JsonObject():new())
        nPos := Len(aItem)

        aItem[nPos]['nota_origem']     := (cAlias)->D2_DOC
        aItem[nPos]['serie_origem']    := (cAlias)->F2_SERIE
        aItem[nPos]['item_origem']     := (cAlias)->D2_ITEM 
        aItem[nPos]['produto']         := (cAlias)->D2_COD    
        aItem[nPos]['quantidade']      := (cAlias)->USADO 
        aItem[nPos]['preco_venda']     := (cAlias)->D2_PRCVEN
        aItem[nPos]['valor_total']     := (cAlias)->TOTAL

    (cAlias)->(dbSkip())
    EndDo
EndIf
(cAlias)->(DbCloseArea())

If Len(aItem) > 0

    oDev:set(aItem)

    // Json to String
    cResponse := oDev:toJson()

    // Define tipo de retorno.
    self:SetContentType('application/json')

    // Define resposta.
    self:SetResponse( EncodeUTF8( cResponse ) )
EndIf

RpcClearEnv()
RestArea(aArea)
Return .T.

