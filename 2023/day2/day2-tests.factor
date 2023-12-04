! Copyright (C) 2023 Jonathan Klabunde Tomer.
! See https://factorcode.org/license.txt for BSD license.
USING: tools.test day2 day2.private ;
IN: day2.tests

{ { T{ draw f 4 0 3 } T{ draw f 1 2 6 } T{ draw f 0 2 0 } } } [ "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" parse-game ] unit-test
{ { T{ draw f 0 2 1 } T{ draw f 1 3 4 } T{ draw f 0 1 1 } } } [ "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" parse-game ] unit-test
{ { T{ draw f 20 8 6 } T{ draw f 4 13 5 } T{ draw f 1 5 0 } } } [ "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red" parse-game ] unit-test
{ { T{ draw f 3 1 6 } T{ draw f 6 3 0 } T{ draw f 14 3 15 } } } [ "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red" parse-game ] unit-test
{ { T{ draw f 6 3 1 } T{ draw f 1 2 2 } } } [ "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" parse-game ] unit-test

{ { 4 2 6 } } [ "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" mincubes ] unit-test
{ { 1 3 4 } } [ "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" mincubes ] unit-test
{ { 20 13 6 } } [ "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red" mincubes ] unit-test
{ { 14 3 15 } } [ "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red" mincubes ] unit-test
{ { 6 3 2 } } [ "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" mincubes ] unit-test

{ t } [ "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" possible ] unit-test
{ t } [ "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" possible ] unit-test
{ f } [ "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red" possible ] unit-test
{ f } [ "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red" possible ] unit-test
{ t } [ "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" possible ] unit-test

{ 48 } [ "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" power ] unit-test
{ 12 } [ "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" power ] unit-test
{ 1560 } [ "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red" power ] unit-test
{ 630 } [ "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red" power ] unit-test
{ 36 } [ "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" power ] unit-test

{ { 1 2 5 } } [ { "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
                  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
                  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
                  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
                  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" } part1 ] unit-test

