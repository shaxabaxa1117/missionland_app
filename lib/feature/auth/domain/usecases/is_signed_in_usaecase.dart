

import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';

class IsSignedInUsecase {
  final AuthRepository authRepository;

  IsSignedInUsecase({required this.authRepository});

  Future<bool> call() async {
    return await authRepository.isSignedIn();
  }
}
