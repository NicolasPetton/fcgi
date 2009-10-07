Object subclass: FCGIProtocolVersion1 [
    | stream recordCollection recordCollectionOut requestId handler requestParams |
    
    <category: 'FastCGI-Protocol'>
    <comment: nil>

    FCGIProtocolVersion1 class [| logging |]

    CrLf := nil.
    ProtocolVersion := nil.
    RecordTypes := nil.

    FCGIProtocolVersion1 class >> initialize [
	"FCGIProtocolVersion1 initialize"

	CrLf := Character cr asString , Character lf asString.
	ProtocolVersion := FCGIVersion1 new.
	RecordTypes := Dictionary new.
	self recordTypesArray do: [:each | RecordTypes add: each]
    ]

    FCGIProtocolVersion1 class >> new [
	<category: 'instance creation'>
	^self basicNew initialize
    ]

    FCGIProtocolVersion1 class >> logging [
	^logging ifNil: [logging := false]
    ]

    FCGIProtocolVersion1 class >> logging: aBoolean [
	^logging := aBoolean
    ]

    FCGIProtocolVersion1 class >> on: aStream withHandler: aHandler [
	^(self new)
	    handler: aHandler;
	    startOn: aStream;
	    yourself
    ]

    FCGIProtocolVersion1 class >> recordTypesArray [
	^
	{ProtocolVersion beginRequest -> FCGIBeginRequestRecord.
	ProtocolVersion abortRequest -> FCGIDefaultRecord.
	ProtocolVersion endRequest -> FCGIDefaultRecord.
	ProtocolVersion params -> FCGIParamRecord.
	ProtocolVersion stdin -> FCGIDefaultRecord.
	ProtocolVersion stdout -> FCGIDefaultRecord.
	ProtocolVersion stderr -> FCGIDefaultRecord.
	ProtocolVersion data -> FCGIDefaultRecord.
	ProtocolVersion getValue -> nil.
	ProtocolVersion getValueResult -> nil.
	ProtocolVersion unknownType -> FCGIUnknownTypeRecord}
    ]

    answerRequest [
	<category: 'request'>
	| response |
	self handler isNil 
	    ifFalse: [
		response := self handler process: self request.
		self sendStdout: response]
	    ifTrue: [
		self sendHTML: '<html><head></head><body>
			<h1>GNU-Smalltalk/FCGI is running</h1>
			No handler set.</body></html>']
    ]

    requestLoop [
	<category: 'request'>
	| begin |
	[begin := self readRecord: FCGIBeginRequestRecord] 
	    on: Error
	    do: [:error | 
		self log: 'disconnect'.
		^false].
	self log: 'request'.
	
	[| record |
	requestId := begin header requestId.
	requestParams := self readRecord: FCGIParamRecord.

	[record := self readAnyRecord] 
	    doWhileFalse: [record type = ProtocolVersion stdin].
	requestParams post: record content.
	self answerRequest.
	self sendStdout: ''.
	self sendEndRequest.
	stream flush] 
		on: Error
		do: [:error | 
		    error pass.
		    self log: 'requesterror'.
		    ^false].

	"multiple requests in a single connection when supported by the server"
	^begin flags = ProtocolVersion keepConnection
    ]

    startOn: aStream [
	<category: 'request'>
	stream := aStream.
	self log: 'openConnection'.
	self startRequestLoop.
	self log: 'closeConnection'
    ]

    startRequestLoop [
	<category: 'request'>
	    [self requestLoop] whileTrue
    ]

    handler [
	<category: 'logging'>
	^handler
    ]

    handler: anObject [
	<category: 'logging'>
	handler := anObject
    ]

    ifLogging: aBlock [
	<category: 'logging'>
	self class logging ifTrue: aBlock
    ]

    log: aString [
	<category: 'logging'>
	self ifLogging: [
	    Transcript
		show: 'FCGI>>' , aString;
		cr]
    ]

    logIncoming: record [
	<category: 'logging'>
	self ifLogging: [recordCollection add: record].
	^record
    ]

    logOutgoing: record [
	<category: 'logging'>
	self ifLogging: [recordCollectionOut add: record].
	^record
    ]

    initialize [
	<category: 'initialize-release'>
	recordCollection := OrderedCollection new.
	recordCollectionOut := OrderedCollection new
    ]

    instanceOfRecord: type [
	<category: 'records'>
	^(RecordTypes at: type) new
    ]

    readAnyRecord [
	<category: 'records'>
	^self logIncoming: (self readFrom: stream)
    ]

    readFrom: aStream [
	<category: 'records'>
	| header record |
	header := FCGIHeader new readFrom: aStream.
	(header version = 1) ifFalse: [self error: 'Wrong header version'].
	record := self instanceOfRecord: header type.
	record header: header.
	record readFrom: aStream.
	^record
    ]

    readRecord: recordClass [
	<category: 'records'>
	| record |
	record := self readAnyRecord.
	(record class = recordClass) ifFalse: [self error: 'Wrong record class'].
	^record
    ]

    sendEndRequest [
	<category: 'records'>
	| record |
	record := FCGIEndRequestRecord type: ProtocolVersion endRequest.
	record
	    appStatus: 0;
	    protocolStatus: ProtocolVersion requestComplete.
	self sendRecord: record
    ]

    sendHTML: aString [
	<category: 'records'>
	self sendStdout: 'Content-type: text/html' , CrLf , CrLf , aString
    ]

    sendRecord: aRecord [
	<category: 'records'>
	(aRecord header)
	    version: ProtocolVersion version;
	    requestId: requestId;
	    storeOn: stream.
	self logOutgoing: aRecord.
	aRecord storeOn: stream
    ]

    sendStdout: aString [
	<category: 'records'>
	| byteCount |
	byteCount := 0.
	[byteCount < aString size] whileTrue: [
	    | amount record |
	    amount := aString size - byteCount min: 65536 - 1.
	    record := FCGIDefaultRecord type: ProtocolVersion stdout.
	    record content: (aString copyFrom: byteCount + 1 to: byteCount + amount).
	    self sendRecord: record.
	    byteCount := byteCount + amount]
    ]

    request [
	<category: 'accessing'>
	^requestParams
    ]
]



Eval [
    FCGIProtocolVersion1 initialize
]

