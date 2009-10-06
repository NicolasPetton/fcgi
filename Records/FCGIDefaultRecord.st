FCGIRecord subclass: FCGIDefaultRecord [
    | contentData paddingData |
    
    <comment: nil>
    <category: 'FastCGI-Records'>

    content [
	^contentData
    ]

    content: aString [
	contentData := aString.
	self ensureHeader contentLength: aString size
    ]

    readFrom: aStream [
	contentData := aStream next: header contentLength.
	paddingData := aStream next: header paddingLength
    ]

    storeOn: aStream [
	aStream nextPutAll: contentData.
	self header paddingLength printNl.
	1 to: self header paddingLength do: [:each | aStream uint8: 0]
    ]
]

