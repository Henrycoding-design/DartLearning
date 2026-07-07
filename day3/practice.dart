import 'dart:math';
double rectPerimeter(double length, double width) {
  return (length+width)*2;
}

double trianglePerimeter(double a, double b, double c) {
  return a+b+c;
}

double triangleArea(double base, double height) {
  return base*height*1/2;
}

double solveEquationLev1(double a, double b) {
  return -b/a;
}

double solveEquationLev2(double a, double b){
  return sqrt(-b/a);
}

void main() {
  print("Bai1: ${rectPerimeter(1,2)}");

  print("Bai2: Chu vi:${trianglePerimeter(1, 2, 3)} Dien tich: ${triangleArea(1, 2)}");

  print("Bai3: Bac1: ${solveEquationLev1(1, 2)} Bac2: ${solveEquationLev2(1, 2)}");
}
