
import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';
class SignUpUsecase {
  AuthRepository authRepository;
  SignUpUsecase({required this.authRepository});

  
  Future<void> call(String email, String password) async {
    return await authRepository.signUp(email: email, password: password);
  }


}