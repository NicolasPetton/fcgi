Object subclass: FCGIVersion1 [
    
    <category: 'FastCGI-Protocol'>
    <comment: nil>

    abortRequest [
	<category: 'header-constants'>
	^2
    ]

    beginRequest [
	<category: 'header-constants'>
	^1
    ]

    data [
	<category: 'header-constants'>
	^8
    ]

    endRequest [
	<category: 'header-constants'>
	^3
    ]

    getMaxtype [
	<category: 'header-constants'>
	^self unknownType
    ]

    getValue [
	<category: 'header-constants'>
	^9
    ]

    getValueResult [
	<category: 'header-constants'>
	^10
    ]

    headerLength [
	<category: 'header-constants'>
	^8
    ]

    params [
	<category: 'header-constants'>
	^4
    ]

    stderr [
	<category: 'header-constants'>
	^7
    ]

    stdin [
	<category: 'header-constants'>
	^5
    ]

    stdout [
	<category: 'header-constants'>
	^6
    ]

    unknownType [
	<category: 'header-constants'>
	^11
    ]

    version [
	<category: 'header-constants'>
	^1
    ]

    authorizer [
	<category: 'role-constants'>
	^2
    ]

    filter [
	<category: 'role-constants'>
	^3
    ]

    responder [
	<category: 'role-constants'>
	^1
    ]

    cantMultiplexConnection [
	<category: 'request-constants'>
	
    ]

    keepConnection [
	<category: 'request-constants'>
	^1
    ]

    nullRequestID [
	<category: 'request-constants'>
	^0
    ]

    overloaded [
	<category: 'request-constants'>
	^2
    ]

    requestComplete [
	<category: 'request-constants'>
	^0
    ]

    unkownRole [
	<category: 'request-constants'>
	^3
    ]

    maxConnections [
	<category: 'config-defaults'>
	^1
    ]

    maxRequests [
	<category: 'config-defaults'>
	^1
    ]

    multiplexConnections [
	<category: 'config-defaults'>
	^0
    ]
]

