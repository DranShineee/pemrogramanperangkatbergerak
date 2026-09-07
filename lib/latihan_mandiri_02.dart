class Profil {
  String nama;
  String nim;
  String? emailKampus;

  Profil({
    required this.nama,
    required this.nim,
    this.emailKampus,
  });

  void tampilkanInfo() {
    String tampilEmail = emailKampus ?? '(belum ada email)';
    print('[$nim] $nama | Email: $tampilEmail');
  }
}

void main() {
  Profil profil1 = Profil(
    nama: 'Khairan Adiokta Arun Nugraha',
    nim: '362558302097',
    emailKampus: 'khairan@poliwangi.ac.id',
  );

  Profil profil2 = Profil(
    nama: 'Ayaska Fernanado',
    nim: '362558202142',
  );

  profil1.tampilkanInfo();
  profil2.tampilkanInfo();
}