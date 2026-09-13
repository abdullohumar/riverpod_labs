abstract class UserRepository {
  Future<String> fetchUserName();
}

class UserApiRepository implements UserRepository {
  @override
  Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Ada Lovelace';
  }
}
