USING: tools.test day3 day3.private ;
IN: day3.tests

: test-input ( -- str )
"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.." ;

{ "123" "..456" } [ "123..456" split-digits ] unit-test

{ { T{ datum f 0 0 2 467 } T{ datum f 0 5 7 114 } } } [ "467..114.." parse-line ] unit-test

{
    { T{ datum f 0 0 2 467 } T{ datum f 0 5 7 114 }
      T{ datum f 2 2 3 35 } T{ datum f 2 6 8 633 }
      T{ datum f 4 0 2 617 }
      T{ datum f 5 7 8 58 }
      T{ datum f 6 2 4 592 }
      T{ datum f 7 6 8 755 }
      T{ datum f 9 1 3 664 } T{ datum f 9 5 7 598 } }
    { T{ symbol f 1 3 t } T{ symbol f 3 6 f } T{ symbol f 4 3 t } T{ symbol f 5 5 f } T{ symbol f 8 3 f } T{ symbol f 8 5 t } }
} [ test-input parse ] unit-test

{ t } [ T{ symbol f 1 2 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 1 3 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 1 4 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 1 5 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 1 6 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 2 2 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 2 6 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 3 2 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 3 3 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 3 4 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 3 5 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ t } [ T{ symbol f 3 6 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 0 2 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 0 4 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 1 1 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 1 7 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 2 1 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 2 7 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 3 1 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 3 7 } T{ datum f 2 3 5 123 } adjacent? ] unit-test
{ f } [ T{ symbol f 4 4 } T{ datum f 2 3 5 123 } adjacent? ] unit-test

{ { 467 35 633 617 592 755 664 598 } } [ test-input parse part-numbers ] unit-test
{ 4361 } [ test-input part1 ] unit-test

{ { 16345 451490 } } [ test-input parse gear-ratios ] unit-test
{ 467835 } [ test-input part2 ] unit-test

