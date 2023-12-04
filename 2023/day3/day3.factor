USING: accessors assocs combinators combinators.short-circuit
io.encodings.utf8 io.files kernel math math.parser sequences splitting unicode
;
IN: day3

<PRIVATE

TUPLE: datum { y integer } { xmin integer } { xmax integer } { val integer } ;
TUPLE: symbol { y integer } { x integer } { gear boolean } ;

: <datum> ( xmin xmax val -- datum ) [ 0 ] 3dip datum boa ;
: <symbol> ( x -- symbol ) 0 swap f symbol boa ;
: <gear> ( x -- gear ) 0 swap t symbol boa ;

: split-digits ( str -- digits str' ) dup [ digit? not ] find [ cut ] [ drop "" ] if ;
: parse-line-help ( line accum x -- data )
    {
        { [ pick empty? ] [ rot 2drop ] }
        { [ pick first CHAR: . = ] [ [ rest ] 2dip 1 + parse-line-help ] }
        { [ pick first CHAR: * = ] [ [ rest ] 2dip [ <gear> suffix ] keep 1 + parse-line-help ] }
        { [ pick first digit? not ] [ [ rest ] 2dip  [ <symbol> suffix ] keep 1 + parse-line-help ] }
        [
            rot split-digits [
                [ length ] [ string>number ] bi
                [ over + [ 1 - ] keep ] dip swap 
                [ <datum> suffix ] dip
            ] dip -rot parse-line-help
        ]
    } cond ; recursive
    
: parse-line ( line -- data ) { } 0 parse-line-help ;

: parse ( input -- data symbols ) split-lines zip-index [ [ first parse-line ] [ second [ >>y ] curry map ] bi ] map concat [ datum? ] partition ;

: adjacent? ( symbol datum -- ? )
    { [ y>> swap y>> { [ 1 - >= ] [ 1 + <= ] } 2&& ]
      [ xmin>> 1 - swap x>> <= ]
      [ xmax>> 1 + swap x>> >= ] } 2&& ;

: part-numbers ( data symbols -- numbers ) [ swap [ adjacent? ] curry any? ] curry filter [ val>> ] map ;

: gear-ratio ( data gear -- ratio ) [ swap adjacent? ] curry filter [ length 2 = ] [ [ val>> ] map product ] bi and ;
: gear-ratios ( data symbols -- ratios ) [ gear>> ] filter [ dupd gear-ratio ] map [ ] filter nip ;

PRIVATE>

: part1 ( contents -- answer ) parse part-numbers sum ;
: part1f ( path -- answer ) utf8 file-contents part1 ;
: part2 ( contents -- answer ) parse gear-ratios sum ;
: part2f ( path -- answer ) utf8 file-contents part2 ;
