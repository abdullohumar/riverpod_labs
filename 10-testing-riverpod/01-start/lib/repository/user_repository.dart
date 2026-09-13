/// Repository yang ABSTRACT. Bergantung pada tipe abstract (sebuah
/// interface), bukan class konkret, adalah yang membuat `overrideWithValue`
/// di test bisa dilakukan: provider hanya menjanjikan "sesuatu yang bisa
/// fetchUserName," bukan "khususnya sebuah panggilan network."
abstract class UserRepository {
  Future<String> fetchUserName();
}

/// Implementasi asli yang benar-benar dipakai aplikasi.
class UserApiRepository implements UserRepository {
  @override
  Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Ada Lovelace';
  }
}
