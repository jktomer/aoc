USING: assocs io.encodings.utf8 io.files kernel math math.order math.parser
mirrors sequences splitting unicode ;
IN: day2

<PRIVATE

TUPLE: draw { red integer } { green integer } { blue integer } ;

: parse-component ( draw str -- draw ) [ digit? ] partition [ string>number ] dip pick <mirror> set-at ;

: parse-draw ( str -- draw ) draw new swap "," split [ dupd parse-component ] map drop ;

: parse-game ( str -- game ) [ blank? not ] filter ";" split [ parse-draw ] map ;

: mincubes ( gamestr -- rgb ) parse-game { 0 0 0 } [ <mirror> values [ max ] 2map ] reduce ;

: possible ( gamestr -- ? ) mincubes { 12 13 14 } [ max ] 2map { 12 13 14 } = ;

: power ( gamestr -- n ) mincubes 1 [ * ] reduce ;

PRIVATE>

: part1 ( lines -- result ) [ ":" split second possible ] map zip-index [ first ] filter [ second 1 + ] map ;
: part1f ( path -- result ) utf8 file-lines part1 sum ;
: part2f ( path -- result ) utf8 file-lines [ ":" split second power ] map sum ;
