FCGIRecord subclass: FCGIUnknownTypeRecord [
    | type reserved |
    
    <comment: nil>
    <category: 'FastCGI-Records'>

    readFrom: aStream [
	type := aStream uint8.
	reserved := aStream next: 7
    ]
]
