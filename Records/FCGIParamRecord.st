FCGIRecord subclass: FCGIParamRecord [
    | namesAndValues cookies post fields postFields getFields |
    
    <comment: nil>
    <category: 'FastCGI-Records'>


    initialize [
	<category: 'initialize-release'>
	super initialize.
	namesAndValues := OrderedCollection new
    ]

    at: aKey [
	<category: 'accessing'>
	^(namesAndValues detect: [:assoc | assoc key = aKey]) value
    ]

    at: aKey ifAbsent: aBlock [
	<category: 'accessing'>
	^(namesAndValues 
	    detect: [:assoc | assoc key = aKey] 
	    ifNone: aBlock) value
    ]

    at: aKey put: aValue [
	<category: 'accessing'>
	namesAndValues add: aKey -> aValue
    ]

    post [
	<category: 'accessing'>
	^post
    ]

    post: aString [
	<category: 'accessing'>
	post := aString
    ]

    cookieString [
	<category: 'smartaccessing'>
	^self at: 'HTTP_COOKIE' ifAbsent: ['']
    ]

    cookies [
	<category: 'smartaccessing'>
	^cookies ifNil: [
	    cookies := self 
		parseToFields: self cookieString 
		separatedBy: $;]
    ]

    fields [
	<category: 'smartaccessing'>
	^fields ifNil: [
	    fields := (Dictionary new)
		addAll: self postFields;
		addAll: self getFields;
		yourself]
    ]

    getFields [
	<category: 'smartaccessing'>
	^getFields ifNil: [
	    getFields := self 
		parseToFields: self query 
		separatedBy: $&]
    ]

    header [
	<category: 'smartaccessing'>
	^self
    ]

    method [
	<category: 'smartaccessing'>
	^self at: 'REQUEST_METHOD'
    ]

    postFields [
	<category: 'smartaccessing'>
	^postFields ifNil: [
	    postFields := self method = 'POST' 
		ifTrue: [
		    self 
			parseToFields: self post unescapePercents 
			separatedBy: $&]
		ifFalse: [Dictionary new]]
    ]

    query [
	<category: 'smartaccessing'>
	^self at: 'QUERY_STRING'
    ]

    url [
	"namesAndValues explore."
	<category: 'smartaccessing'>

	^(self at: 'SCRIPT_NAME') , (self at: 'PATH_INFO')
    ]

    parseToFields: aString separatedBy: char [
	<category: 'reading'>
	| equal tempFields |
	tempFields := Dictionary new.
	aString ifNotNil: [
	    (aString subStrings: {char}) do: [:each | 
		equal := each indexOf: $=.
		equal = 0 
		    ifTrue: [tempFields at: each put: nil]
		    ifFalse: [
			tempFields 
			    at: (each first: equal - 1) 
			    put: (each allButFirst: equal)]]].
	^tempFields
    ]

    readFrom: aStream [
	<category: 'reading'>
	| buffer stream |
	buffer := aStream next: header contentLength.
	stream := ReadStream on: buffer.
	[stream atEnd] whileFalse: [self readNameValueFrom: stream]
    ]

    readNameValueFrom: aStream [
	<category: 'reading'>
	| nameLength valueLength name value |
	nameLength := aStream uint8.
	(nameLength bitShift: -7) = 0 ifFalse: [
	    nameLength := (nameLength bitShift: 24) + aStream uint24].
	valueLength := aStream uint8.
	(valueLength bitShift: -7) = 0 ifFalse: 
	    [valueLength := (valueLength bitShift: 24) + aStream uint24].
	name := aStream next: nameLength.
	value := aStream next: valueLength.
	self at: name put: value
    ]
]

