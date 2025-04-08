class SignupModel {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String bio;

  SignupModel(
      {required this.fullName,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.bio});
}
