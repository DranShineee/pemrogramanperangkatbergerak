double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

void main() {
  double panjang = 7.1;
  double lebar = 5.0;

  double luas = hitungLuasPersegiPanjang(panjang, lebar);

  print('Luas: ${luas.toStringAsFixed(2)} cm²');
}