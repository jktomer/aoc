USING: day1 day1.private tools.test ;
IN: day1.tests

{ 12 } [ "1abc2" line>num ] unit-test
{ 38 } [ "pqr3stu8vwx" line>num ] unit-test
{ 15 } [ "a1b2c3d4e5f" line>num ] unit-test
{ 77 } [ "treb7uchet" line>num ] unit-test

{ 2 } [ "two1nine" firstdigit ] unit-test
{ 8 } [ "eightwothree" firstdigit ] unit-test
{ 1 } [ "abcone2threexyz" firstdigit ] unit-test
{ 2 } [ "xtwone3four" firstdigit ] unit-test
{ 4 } [ "4nineeightseven2" firstdigit ] unit-test
{ 1 } [ "zoneight234" firstdigit ] unit-test
{ 7 } [ "7pqrstsixteen" firstdigit ] unit-test

{ 9 } [ "two1nine" lastdigit ] unit-test
{ 3 } [ "eightwothree" lastdigit ] unit-test
{ 3 } [ "abcone2threexyz" lastdigit ] unit-test
{ 4 } [ "xtwone3four" lastdigit ] unit-test
{ 2 } [ "4nineeightseven2" lastdigit ] unit-test
{ 4 } [ "zoneight234" lastdigit ] unit-test
{ 6 } [ "7pqrstsixteen" lastdigit ] unit-test

{ 29 } [ "two1nine" line>num2 ] unit-test
{ 83 } [ "eightwothree" line>num2 ] unit-test
{ 13 } [ "abcone2threexyz" line>num2 ] unit-test
{ 24 } [ "xtwone3four" line>num2 ] unit-test
{ 42 } [ "4nineeightseven2" line>num2 ] unit-test
{ 14 } [ "zoneight234" line>num2 ] unit-test
{ 76 } [ "7pqrstsixteen" line>num2 ] unit-test

{ 142 } [ { "1abc2" "pqr3stu8vwx" "a1b2c3d4e5f" "treb7uchet" } part1 ] unit-test
{ 281 } [ { "two1nine" "eightwothree" "abcone2threexyz" "xtwone3four" "4nineeightseven2" "zoneight234" "7pqrstsixteen" } part2 ] unit-test
