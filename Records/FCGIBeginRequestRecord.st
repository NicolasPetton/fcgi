FCGIRecord subclass: FCGIBeginRequestRecord [
    | role flags reserved |
    
    <comment: nil>
    <category: 'FastCGI-Records'>

    flags [
	^flags
    ]

    readFrom: aStream [
	role := aStream uint16.
	flags := aStream uint8.
	reserved := aStream next: 5
    ]
]

