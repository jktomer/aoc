#include <iostream>
#include <cstdlib>

using std::cout;
using std::endl;

int sigma(int n) {
  int s = n+1;
  for (int i = 2; i < n; i++) {
    if (n % i == 0)
      s += i;
  }
  return s;
}

int main(int argc, char **argv) {
  int target = atoi(argv[1]), freq = atoi(argv[2]);
  target /= 10;
  for (int candidate = 720720; candidate <= 1441440; candidate++) {
    if (sigma(candidate) >= target) {
      cout << candidate << endl;
      return 0;
    }
    if (candidate % freq == 0) {
      cout << candidate << " " << sigma(candidate) << endl;
    }
  }
  return 1;
}
