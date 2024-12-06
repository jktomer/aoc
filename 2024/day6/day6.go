package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

type Map struct { s int; o [][]bool }
type Point struct {r, c int}
type Dir struct {dr, dc int}
type State struct {p Point; d Dir}

func (d Dir) RotateRight() Dir {
	return Dir{d.dc, -d.dr}
}

func (p Point) Plus(d Dir) Point {
	return Point{p.r + d.dr, p.c + d.dc}
}

func (m *Map) Obstructed(pos Point) bool {
	return pos.r >= 0 && pos.r < m.s && pos.c >= 0 && pos.c < m.s && m.o[pos.r][pos.c]
}

func (m *Map) Block(pos Point) {
	m.o[pos.r][pos.c] = true
}

func (m *Map) Unblock(pos Point) {
	m.o[pos.r][pos.c] = false
}

func (m *Map) Route(pos Point, dir Dir) []State {
	path, seen, loop := []State{}, map[Point]bool{}, map[State]bool{}
	for pos.r >= 0 && pos.r < m.s &&pos.c >= 0 && pos.c < m.s {
		if !seen[pos] {
			path = append(path, State{pos, dir})
		}
		seen[pos] = true
		for m.Obstructed(pos.Plus(dir)) {
			if loop[State{pos, dir}] {
				return nil
			}
			loop[State{pos, dir}] = true
			dir = dir.RotateRight()
		}
		pos = pos.Plus(dir)
	}
	return path
}

func main() {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(strings.TrimSuffix(string(data), "\n"), "\n")
	m := Map{len(lines), make([][]bool, len(lines))}

	p0, d0 := Point{-1, -1}, Dir{-1, 0}
	for r, l := range lines {
		m.o[r] = make([]bool, m.s)
		for c, x := range l {
			if x == '^' {
				p0 = Point{r, c}
			} else if x == '#' {
				m.Block(Point{r, c})
			}
		}
	}
	if p0.r < 0 {
		log.Fatal("no guard found")
	}

	rte := m.Route(p0, d0)
	fmt.Println(len(rte))

	options := 0
	for i := range rte[:len(rte)-1] {
		start := rte[i]
		candidate := rte[i+1]
		if candidate.p == p0 || m.Obstructed(candidate.p) {
			log.Fatalf("wtf: %d, %v", i, candidate)
		}
		m.Block(candidate.p)
		if m.Route(start.p, start.d) == nil {
			options++
		}
		m.Unblock(candidate.p)
	}
	fmt.Println(options)
}
