USING: accessors arrays io.encodings.utf8 io.files kernel math math.parser
sequences sequences.extras sets splitting ;
IN: day4

<PRIVATE

: wins ( card -- wins ) [ first ] [ second ] bi intersect length ;
: score ( card -- score ) wins 1 - 1 swap shift ;
: parse-part ( str -- nums ) " " split [ empty? not ] filter [ string>number ] map ;
: parse-line ( str -- card ) ":" split second "|" split [ parse-part ] map ;

TUPLE: score-state { remaining array } { total integer } ;
: <score-state> ( remaining total -- score-state ) score-state boa ;

: score2 ( cards -- total-score ) [ wins ] map dup length 1 <array> 0 <score-state>
    [
        [ [ remaining>> [ rest ] [ first ] bi ] dip swap <array> [ + ] 2map! ]
        [ drop [ total>> ] [ remaining>> first ] bi + ]
        2bi <score-state>
    ] reduce total>> ;
PRIVATE>

: part1 ( lines -- total-score ) [ parse-line score ] map sum ;
: part1f ( path -- total-score ) utf8 file-lines part1 ;
: part2 ( lines -- total-score ) [ parse-line ] map score2 ;
: part2f ( path -- total-score ) utf8 file-lines part2 ;
