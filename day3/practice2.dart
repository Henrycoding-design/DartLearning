
bool isEqual(int a, int b) => a == b;

bool isLarger(int x, int y) => x > y;

void main() {
  final int a = 1;
  final int b = 2;
  print("A equal B: ${isEqual(a, b)}");
  print("A not equal B: ${!isEqual(a, b)}");

  final int x = 1;
  final int y = 2;
  print("x larger than y: ${isLarger(x, y)}");
  print("x smaller than y: ${!isLarger(x, y) && !isEqual(x, y)}");


  final int p = 1;
  final int q = 2;
  print("p >= q: ${isLarger(p, q) || isEqual(p, q)}");
  print("p <= q: ${!isLarger(p, q) || isEqual(p, q)}");
}