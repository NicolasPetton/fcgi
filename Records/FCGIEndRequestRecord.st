FCGIRecord subclass: FCGIEndRequestRecord [
    | appStatus protocolStatus reserved |
    
    <comment: nil>
    <category: 'FastCGI-Records'>

    appStatus: anInteger [
	<category: 'accessing'>
	appStatus := anInteger
    ]

    protocolStatus: anInteger [
	<category: 'accessing'>
	protocolStatus := anInteger
    ]

    readFrom: aStream [
	appStatus := aStream uint32.
	protocolStatus := aStream uint8.
	reserved := aStream next: 3
    ]

    storeOn: aStream [
	aStream uint32: appStatus.
	aStream uint8: protocolStatus.
	1 to: 3 do: [:each | aStream uint8: 0]
    ]
]

