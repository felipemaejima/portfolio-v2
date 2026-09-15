import '../../api/models/admin_dto.dart';

/// `unknown` é o AsyncLoading do provider; estes são os estados resolvidos.
sealed class AuthState {
  const AuthState();
}

final class Anonymous extends AuthState {
  const Anonymous();
}

final class Authenticated extends AuthState {
  const Authenticated(this.admin);
  final AdminDto admin;
}
