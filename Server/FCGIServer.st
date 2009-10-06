Object subclass: FCGIServer [
    | handler port socket process |
    
    <category: 'FastCGI-Server'>
    <comment: 'FastCGI Specifiaction at
    http://www.fastcgi.com/devkit/doc/fcgi-spec.html'>

    FCGIServer class [
	startInBackground [
	    self new openInProcess
	]
    ]

    acceptLoop [
	| requestSocket |
	requestSocket := socket waitForConnection; accept.
	requestSocket ifNotNil: [
	    [self protocol 
		on: requestSocket 
		withHandler: self handler] 
	    ensure: [requestSocket flush; close]]
    ]

    listen [
	[self acceptLoop] repeat
    ]

    open [
	socket := Sockets.ServerSocket port: self port.
	[self listen] ensure: [socket flush; close]
    ]

    openInProcess [
	process := [self open] 
	    forkAt: Processor userBackgroundPriority
    ]

    port [
	^port ifNil: [port := 9000]
    ]

    port: anInteger [
	port := anInteger
    ]

    protocol [
	^FCGIProtocolVersion1
    ]

    stop [
	process ifNotNil: [
	    process isTerminated ifFalse: [
		process terminate]]
    ]

    handler [
	<category: 'accessing'>
	^handler
    ]

    handler: anObject [
	<category: 'accessing'>
	handler := anObject
    ]

    socket [
	"Answer the value of socket"

	<category: 'accessing'>
	^socket
    ]

    socket: anObject [
	"Set the value of socket"

	<category: 'accessing'>
	socket := anObject
    ]
]

