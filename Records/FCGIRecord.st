Object subclass: FCGIRecord [
    | header |
    
    <category: 'FastCGI-Records'>
    <comment: nil>

    FCGIRecord class >> type: anInteger [
	<category: 'instance creation'>
	^self new type: anInteger
    ]
    
    FCGIRecord class >> new [
	<category: 'instance creation'>
	^self basicNew initialize
    ]

    initialize [
	<category: 'initialize-release'>
    ]

    ensureHeader [
	^self header ifNil: [header := FCGIHeader new]
    ]

    type [
	<category: 'accessing'>
	^header type
    ]

    type: anInteger [
	<category: 'accessing'>
	self ensureHeader type: anInteger
    ]

    header [
	<category: 'accessing'>
	^header
    ]

    header: anObject [
	<category: 'accessing'>
	header := anObject
    ]
]

