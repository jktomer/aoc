package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

var count int
func recursive(d1, d2 []uint8) (p1wins bool, deck []uint8) {
	seen := make(map[string]bool)
	for len(d1) > 0 && len(d2) > 0 {
		s := string(d1) + ":" + string(d2)
		if seen[s] {
			return true, append(d1, d2...)
		}
		seen[s] = true

		c1, c2 := d1[0], d2[0]
		d1, d2 = d1[1:], d2[1:]
		p1wins := false
		if int(c1) <= len(d1) && int(c2) <= len(d2) {
			d1b := append([]uint8{}, d1[:c1]...)
			d2b := append([]uint8{}, d2[:c2]...)
			p1wins, _ = recursive(d1b, d2b)
		} else {
			p1wins = c1 > c2
		}
		if p1wins {
			d1 = append(d1, c1, c2)
		} else {
			d2 = append(d2, c2, c1)
		}
	}
	if len(d1) > 0 {
		return true, d1
	} else {
		return false, d2
	}
}

func main() {
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	s := bufio.NewScanner(f)
	var d1, d2 []uint8
	p := &d1
	for s.Scan() {
		l := s.Text()
		if len(l) == 0 {
			p = &d2
			continue
		}
		if l[len(l)-1] == ':' {
			continue
		}
		n, err := strconv.ParseInt(l, 10, 8)
		if err != nil {
			log.Fatalf("invalid line: %s", l)
		}
		*p = append(*p, uint8(n))
	}
	_, deck := recursive(d1, d2)
	score := 0
	for i, v := range deck {
		score += (len(deck) - i) * int(v)
	}
	fmt.Println(deck, score)
}
