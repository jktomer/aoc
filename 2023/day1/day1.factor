USING: combinators io.encodings.ascii io.files kernel math sequences unicode ;
IN: day1

<PRIVATE
: digval ( digit -- number ) CHAR: 0 - ; inline

: digits ( -- digits ) { { -1 } "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" } ; inline

: line>num ( seq -- num ) [ digit? ] filter [ first digval 10 * ] [ last digval ] bi + ;
PRIVATE>

: part1 ( lines -- sum ) [ line>num ] map sum ;
: part1f ( path -- answer ) ascii file-lines part1 ;

<PRIVATE
: lastdigit ( seq -- num )
    {
        { [ dup empty? ] [ drop f ] }
        { [ dup last digit? ] [ last digval ] }
        { [ digits [ dupd tail? ] any? ] [ digits [ dupd tail? ] find rot 2drop ] }
        [ but-last lastdigit ]
    } cond ; recursive

: firstdigit ( seq -- num )
    {
        { [ dup empty? ] [ drop f ] }
        { [ dup first digit? ] [ first digval ] }
        { [ digits [ dupd head? ] any? ] [ digits [ dupd head? ] find rot 2drop ] }
        [ rest firstdigit ]
    } cond ; recursive

: line>num2 ( seq -- num ) [ lastdigit ] [ firstdigit ] bi 10 * + ;
PRIVATE>

: part2 ( lines -- sum ) [ line>num2 ] map sum ;
: part2f ( path -- answer ) ascii file-lines part2 ;
