USING: arrays io.encodings.utf8 io.files kernel math math.parser ranges
sequences sets splitting ;
IN: day4

<PRIVATE

: wins ( card -- wins ) [ first ] [ second ] bi intersect length ;
: score ( card -- score ) wins 1 - 1 swap shift ;
: parse-part ( str -- nums ) " " split [ empty? not ] filter [ string>number ] map ;
: parse-line ( str -- card ) ":" split second "|" split [ parse-part ] map ;

: score2 ( cards -- total-score ) [ wins ] map dup length 1 <array> [
        swap [ dup pick ?nth swap dup ] dip + (a..b]
        [ [ pick ?nth dupd + ] keep reach set-nth ] each drop
    ] reduce-index sum ;
PRIVATE>

: part1 ( lines -- total-score ) [ parse-line score ] map sum ;
: part1f ( path -- total-score ) utf8 file-lines part1 ;
: part2 ( lines -- total-score ) [ parse-line ] map score2 ;
: part2f ( path -- total-score ) utf8 file-lines part2 ;
