
import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';
class SignOutUsecase {
  final AuthRepository authRepository;

  SignOutUsecase({required this.authRepository});

  Future<void> call() async {
    return await authRepository.signOut();
  }
}
