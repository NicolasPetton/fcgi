BlockClosure extend [

    doWhileFalse: conditionBlock [
	"Evaluate the receiver once, then again as long the value of conditionBlock is false."
 
	| result |
	[result := self value.
	conditionBlock value] whileFalse.

	^ result
    ]
]

Sockets.Socket extend [
  
    next: anInteger [^impl next: anInteger]
    nextPutByteArray: anInteger [^impl nextPutByteArray: anInteger]

    uint8 [
	| r |
	r := impl nextBytes: 1 signed: false.
	^r
    ]

    uint8: anInteger [
	"Store the given unsigned, 8-bit integer on this stream."

	(anInteger < 0) | (anInteger >= 8r10000)
		ifTrue: [self error: 'outside unsigned 16-bit integer range'].
	impl nextPutBytes: 1 of: anInteger
    ] 

    uint16 [
	"Answer the next unsigned, 16-bit integer from this stream."

	| n |
	n := self uint8.
	n := (n bitShift: 8) + (self uint8).
	^n
    ]

    uint16: anInteger [
	"Store the given unsigned, 16-bit integer on this stream."

	(anInteger < 0) | (anInteger >= 16r10000)
		ifTrue: [self error: 'outside unsigned 16-bit integer range'].
	self uint8: (anInteger digitAt: 2).
	self uint8: (anInteger digitAt: 1)
    ]

    uint24 [
	"Answer the next unsigned, 24-bit integer from this stream."

	| n |
	n := self uint8.
	n := (n bitShift: 8) + (self uint8).
	n := (n bitShift: 8) + (self uint8).
	^n
    ]

    uint32 [
	"Answer the next unsigned, 32-bit integer from this stream."

	| n |
	n := self uint8.
	n := (n bitShift: 8) + (self uint8).
	n := (n bitShift: 8) + (self uint8).
	n := (n bitShift: 8) + (self uint8).
	
    ]

    uint32: anInteger [
	(anInteger < 0) | (anInteger >= 16r100000000)
		ifTrue: [self error: 'outside unsigned 32-bit integer range'].

	self uint8: (anInteger digitAt: 4).
	self uint8: (anInteger digitAt: 3).
	self uint8: (anInteger digitAt: 2).
	self uint8: (anInteger digitAt: 1).
    ]

    crlf [impl nextPutAll: String crlf]
]


Stream extend [
    
    uint8 [
	^self next asInteger
    ]

    uint16 [
	"Answer the next unsigned, 16-bit integer from this (binary) stream."

	| n |
	n := self next.
	n := (n bitShift: 8) + (self next).
	^ n
    ]

    uint16: anInteger [
	"Store the given unsigned, 16-bit integer on this (binary) stream."

	(anInteger < 0) | (anInteger >= 16r10000)
		ifTrue: [self error: 'outside unsigned 16-bit integer range'].

	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).
    ]

    uint24 [
	"Answer the next unsigned, 24-bit integer from this (binary) stream."

	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^ n
    ]

    uint32 [
	"Answer the next unsigned, 32-bit integer from this (binary) stream."

	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^ n
    ]

    uint32: anInteger [
	"Store the given unsigned, 32-bit integer on this (binary) stream."

	(anInteger < 0) | (anInteger >= 16r100000000)
		ifTrue: [self error: 'outside unsigned 32-bit integer range'].

	self nextPut: (anInteger digitAt: 4).
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).
    ]
]


String extend [
    String class >> crlf [
	^self fromString: {Character cr. Character lf}
    ]
]
