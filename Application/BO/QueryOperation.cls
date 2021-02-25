<?xml version="1.0" encoding="UTF-8"?>
<Export generator="Cache" version="25" zv="Cache for Windows (x86-64) 2017.2.2 (Build 865U)" ts="2021-02-25 11:22:50">
<Class name="Tongji.HQS.BO.SQLFromLIS">
<ProcedureBlock>1</ProcedureBlock>
<Super>Ens.BusinessOperation,Ens.Util.FunctionSet</Super>
<TimeChanged>64268,61566.744218</TimeChanged>
<TimeCreated>63777,57476.868314</TimeCreated>

<Parameter name="ADAPTER">
<Default>UserLib.SQL.OutboundAdapter</Default>
</Parameter>

<Property name="Adapter">
<Type>UserLib.SQL.OutboundAdapter</Type>
</Property>

<Parameter name="INVOCATION">
<Default>Queue</Default>
</Parameter>

<Method name="GetDataset">
<FormalSpec>pRequest:EnsLib.EDI.XML.Document,*pResponse:Tongji.HQS.MSG.ResponseDatasetMessage</FormalSpec>
<ReturnType>%Library.Status</ReturnType>
<Implementation><![CDATA[
	set tSC=$$$OK
	;组装SQL
    set tOriginDataTable = pRequest.GetValueAt("/Request/MessageBody/OriginDataTable")
    set tOriginDataFilter = pRequest.GetValueAt("/Request/MessageBody/OriginDataFilter")
	set tSQL = "select * from "_tOriginDataTable_ " where 1=1 and "_$ZCVT(tOriginDataFilter,"I","XML")
	;查询和获取Snapshot
	$$$LOGINFO(tSQL)
	Set tSC = ..Adapter.ExecuteQuery(.tResult,tSQL)	Quit:$$$ISERR(tSC) tSC	
	If $ISOBJECT(tResult){		
		set tStream = ##class(%GlobalCharacterStream).%New()
    	Set tSnapshot = ##class(UserLib.SQL.Snapshot).%New()
    	set tSnapshot.MaxRowsToGet = -1
    	do tResult.GetSnapshot(.tSnapshot,1)
		set tSC = tSnapshot.XMLExportToStream(.tStream,"Top","literal")	Quit:$$$ISERR(tSC) tSC
		set tEventType="ACK_"_pRequest.GetValueAt("/Request/MessageHeader/EventType")
		set pResponse = ##class(Tongji.HQS.MSG.ResponseDatasetMessage).%New(tEventType,"CA")
		set pResponse.MessageBody.Dataset=tStream
	}		
	Quit $$$OK
]]></Implementation>
</Method>

<XData name="MessageMap">
<Data><![CDATA[
<MapItems>
	<MapItem MessageType="EnsLib.EDI.XML.Document"> 
		<Method>GetDataset</Method>
	</MapItem>
</MapItems>
]]></Data>
</XData>
</Class>
</Export>
