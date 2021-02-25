<?xml version="1.0" encoding="UTF-8"?>
<Export generator="Cache" version="25" zv="Cache for Windows (x86-64) 2017.2.2 (Build 865U)" ts="2021-02-25 11:17:05">
<Class name="Tongji.HQS.MSG.ResponseDatasetMessage">
<Super>Ens.Response</Super>
<TimeChanged>65566,63652.650504</TimeChanged>
<TimeCreated>63755,39735.09322</TimeCreated>

<Property name="MessageHeader">
<Type>Tongji.HQS.MSG.ResponseMessageHeader</Type>
</Property>

<Property name="MessageBody">
<Type>Tongji.HQS.MSG.ResponseMessageBody</Type>
</Property>

<Method name="%OnNew">
<FormalSpec>EventType:%String,ResultCode:%String</FormalSpec>
<Private>1</Private>
<ReturnType>%Status</ReturnType>
<ServerOnly>1</ServerOnly>
<Implementation><![CDATA[
	set ..MessageHeader=##class(Tongji.HQS.MSG.ResponseMessageHeader).%New()
	set ..MessageHeader.Sender="ENS"
	set ..MessageHeader.SendTime=##class(Ens.Util.FunctionSet).CurrentDateTime("%q")
	set ..MessageHeader.MsgId=##class(%SYSTEM.Util).CreateGUID()
	set ..MessageHeader.EventType=EventType
	set ..MessageBody=##class(Tongji.HQS.MSG.ResponseMessageBody).%New()
	set ..MessageBody.Result=##class(Tongji.HQS.MSG.Result).%New()
	set ..MessageBody.Result.Code=ResultCode
	Quit $$$OK
]]></Implementation>
</Method>

<Storage name="Default">
<Type>%Library.CacheStorage</Type>
<DefaultData>ResponseDatasetMessageDefaultData</DefaultData>
<Data name="ResponseDatasetMessageDefaultData">
<Subscript>"ResponseDatasetMessage"</Subscript>
<Value name="1">
<Value>MessageHeader</Value>
</Value>
<Value name="2">
<Value>MessageBody</Value>
</Value>
</Data>
</Storage>
</Class>
</Export>
