enum SuccessType {
  login('Welcome Back!'),
  signUp('Welcome to Plarita!'),
  passwordChanged('Password successfully changed!');

  const SuccessType(this.title);

  final String title;
}
