<?xml version="1.0" encoding="UTF-8"?>
<Export generator="Cache" version="25" zv="Cache for Windows (x86-64) 2017.2.2 (Build 865U)" ts="2021-02-25 11:18:51">
<Class name="Tongji.HQS.BS.HQSServiceTest">
<ProcedureBlock>1</ProcedureBlock>
<Super>EnsLib.SOAP.Service</Super>
<TimeChanged>65799,64719.989212</TimeChanged>
<TimeCreated>63762,40016.323894</TimeCreated>

<Parameter name="ADAPTER">
</Parameter>

<Parameter name="USECLASSNAMESPACES">
<Default>1</Default>
</Parameter>

<Parameter name="NAMESPACE">
<Default>http://tongji.org</Default>
</Parameter>

<Parameter name="SERVICENAME">
<Default>HQS</Default>
</Parameter>

<Parameter name="XMLIGNORENULL">
<Default>1</Default>
</Parameter>

<Method name="XMLService">
<FormalSpec>pInput:%String</FormalSpec>
<ReturnType>%GlobalCharacterStream</ReturnType>
<WebMethod>1</WebMethod>
<Implementation><![CDATA[
	set $ZT = "EXCEPTION", tEventType="", tSC = $$$OK
	do {
		set pos=$F(pInput,"<")-1 If pos>4 set pInput=$E(pInput,pos,*)
		
		;接收入参
		#Dim target As EnsLib.EDI.XML.Document
		set tDocument=##class(EnsLib.EDI.XML.Document).ImportFromString(pInput,.tSC) Quit:$$$ISERR(tSC)
		set tSC = tDocument.DocTypeSet("TongjiExchange:Request") Quit:$$$ISERR(tSC)	
			
		;验证入参
    	set tOriginDataFilter = tDocument.GetValueAt("/Request/MessageBody/OriginDataFilter")
    	if tOriginDataFilter=""  set tSC=$$$ERROR(5001,"入参错误,过滤条件不能为空")  Quit:$$$ISERR(tSC)
    	
 		;To BP or BO 		
 		set tSC = ..ProcessInput(tDocument,.pOutput,"XMLService") Quit:$$$ISERR(tSC) 
 					
	}While(0)
EXIT
	;中转正确值
	If tSC {
		;无返回值表示数据为空，或者源系统名错误
		If $IsObject(pOutput) {
			Do ##class(UserLib.Util.XmlWriter).GetXmlStreamRootObject(pOutput,"Response",.tStream)
			Quit tStream
		}
		set tSC=$$$ERROR(5001,"入参错误")			
	}
	;处理错误和异常
	set tResponse = ##class(Tongji.Soap.Util.CommInstance).GetResponse(tEventType,tSC)
    Do tResponse.XMLExportToStream(.tStream,"Response")
	Quit tStream
EXCEPTION
	set $ZT = "", tSC = $$$EnsSystemError
	goto EXIT
]]></Implementation>
</Method>

<Method name="OnProcessInput">
<FormalSpec><![CDATA[pInput:%RegisteredObject,*pOutput:%RegisteredObject,&pHint:%String]]></FormalSpec>
<ReturnType>%Status</ReturnType>
<Implementation><![CDATA[
	if pHint="XMLService"{	
    	set status = ..SendRequestSync("SQLFromEMRTest",pInput,.pOutput)
	}	
    Quit status
]]></Implementation>
</Method>
</Class>
</Export>
