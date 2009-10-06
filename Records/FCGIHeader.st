Object subclass: FCGIHeader [
    | version type requestId contentLength paddingLength reserved |
    
    <category: 'FastCGI-Records'>
    <comment: nil>

    contentLength [
	<category: 'accessing'>
	^contentLength ifNil: [0]
    ]

    contentLength: anInteger [
	<category: 'accessing'>
	contentLength := anInteger
    ]

    paddingLength [
	<category: 'accessing'>
	^paddingLength ifNil: [0]
    ]

    requestId [
	<category: 'accessing'>
	^requestId
    ]

    requestId: anInteger [
	<category: 'accessing'>
	requestId := anInteger
    ]

    type [
	<category: 'accessing'>
	^type
    ]

    type: anInteger [
	<category: 'accessing'>
	type := anInteger
    ]

    version [
	<category: 'accessing'>
	^version
    ]

    version: anInteger [
	<category: 'accessing'>
	version := anInteger
    ]

    readFrom: aStream [
	version := aStream uint8.
	type := aStream uint8.
	requestId := aStream uint16.
	contentLength := aStream uint16.
	paddingLength := aStream uint8.
	reserved := aStream uint8
    ]

    storeOn: aStream [
	aStream uint8: version.
	aStream uint8: type.
	aStream uint16: requestId.
	aStream uint16: self contentLength.
	aStream uint8: self paddingLength.
	aStream uint8: 0
    ]
]

