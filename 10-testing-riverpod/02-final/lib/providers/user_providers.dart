import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserApiRepository());

final userNameProvider = FutureProvider<String>((ref) {
  return ref.watch(userRepositoryProvider).fetchUserName();
});
