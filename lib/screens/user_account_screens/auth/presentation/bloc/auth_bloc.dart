import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/auth_facade.dart';
import '../../models/user_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade _authFacade;
  AuthBloc({
    required AuthFacade authFacade,
  })  : _authFacade = authFacade,
        super(AuthInitial()) {
    on<RegisterEvent>(_register);
    on<LoginEvent>(_login);
    on<ForgetPasswordEvent>(_forgetPassword);
    on<ResendForgetPasswordOtpEvent>(_resendForgetPasswordOtp);
    on<VerifyForgotPasswordEvent>(_verifyForgetPassword);
    on<ResetPasswordEvent>(_resetPassword);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<SaveAvatarEvent>(_saveAvatar);
    on<GetMeEvent>(_gettingMe);
    on<ChangePasswordEvent>(_changePassword);
    on<UpdateAccountEvent>(_updateAccount);
  }

  void _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(Registering());
    final failureOrSuccess = await _authFacade.register(
      firstName: event.firstName,
      lastName: event.lastName,
      organizationName: event.organizationName,
      phone: event.phone,
      email: event.email,
      userType: event.userType,
      password: event.password,
      referralCode: event.referralCode,
    );
    failureOrSuccess.fold(
      (error) => emit(RegistrationFail(error.message)),
      (user) => emit(RegistrationSuccessful(user)),
    );
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(Signing());
    final failureOrSuccess = await _authFacade.login(
      emailOrPhone: event.emailOrPhone,
      password: event.password,
    );
    failureOrSuccess.fold(
      (error) => emit(SigningFail(error.message)),
      (user) => emit(SigningSuccessful(user)),
    );
  }

  void _forgetPassword(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgettingPassword());
    final failureOrSuccess = await _authFacade.forgetPassword(
      email: event.email,
    );
    failureOrSuccess.fold(
      (error) => emit(ForgettingPasswordFail(error.message)),
      (user) => emit(ForgettingPasswordSuccessful(user)),
    );
  }

  void _resendForgetPasswordOtp(
      ResendForgetPasswordOtpEvent event, Emitter<AuthState> emit) async {
    emit(ResendForgetPasswordOtp());
    final failureOrSuccess = await _authFacade.forgetPassword(
      email: event.email,
    );
    failureOrSuccess.fold(
      (error) => emit(ResendForgetPasswordOtpFail(error.message)),
      (user) => emit(ResendForgetPasswordOtpSuccessful(user)),
    );
  }

  void _verifyForgetPassword(
      VerifyForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(VerifyingForgetPassword());
    final failureOrSuccess = await _authFacade.verifyForgotPassword(
      email: event.email,
      otp: event.otp,
    );
    failureOrSuccess.fold(
      (error) => emit(VerifyingForgetPasswordFail(error.message)),
      (user) => emit(VerifyingForgetPasswordSuccessful(user)),
    );
  }

  void _resetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResettingPassword());
    final failureOrSuccess = await _authFacade.resetPassword(
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    failureOrSuccess.fold(
      (error) => emit(ResettingPasswordFail(error.message)),
      (user) => emit(ResettingPasswordSuccessful(user)),
    );
  }

  void _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(VerifyingOtp());
    final failureOrSuccess = await _authFacade.verifyOtp(otp: event.otp);
    failureOrSuccess.fold(
      (error) => emit(VerifyingOtpFail(error.message)),
      (user) => emit(VerifyingOtpSuccessful(user)),
    );
  }

  void _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(ResendingOtp());
    final failureOrSuccess = await _authFacade.resendOtp();
    failureOrSuccess.fold(
      (error) => emit(ResendingOtpFail(error.message)),
      (user) => emit(ResendingOtpSuccessful(user)),
    );
  }

  void _gettingMe(GetMeEvent event, Emitter<AuthState> emit) async {
    emit(GettingMe());
    final failureOrSuccess = await _authFacade.me();
    failureOrSuccess.fold(
      (error) => emit(GettingMeFail(error.message)),
      (user) => emit(GettingMeSuccessful(user)),
    );
  }

  void _saveAvatar(SaveAvatarEvent event, Emitter<AuthState> emit) async {
    emit(SavingAvatar());
    final failureOrSuccess = await _authFacade.saveAvatar(avatar: event.avatar);
    failureOrSuccess.fold(
      (error) => emit(SavingAvatarFail(error.message)),
      (message) => emit(SavingAvatarSuccessful(message)),
    );
  }

  void _changePassword(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(ChangingPassword());
    final failureOrSuccess = await _authFacade.changePassword(
      currentPassword: event.currentPassword,
      password: event.password,
      passwordConfirmation: event.confirmPassword,
    );
    failureOrSuccess.fold(
      (error) => emit(ChangingPasswordFail(error.message)),
      (message) => emit(ChangingPasswordSuccessful(message)),
    );
  }

  void _updateAccount(UpdateAccountEvent event, Emitter<AuthState> emit) async {
    emit(UpdatingAccount());
    final failureOrSuccess = await _authFacade.updateUser(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
    );
    failureOrSuccess.fold(
      (error) => emit(UpdatingAccountFail(error.message)),
      (message) => emit(UpdatingAccountSuccessful(message)),
    );
  }
}
