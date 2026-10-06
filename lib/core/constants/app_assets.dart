/// Chemins d'assets Dogbale.
///
/// Les fichiers ne sont pas encore présents — chaque constante attend qu'un
/// asset réel soit déposé dans `assets/images/` et déclaré dans `pubspec.yaml`.
class AppAssets {
  AppAssets._();

  static const String _imagesBase = "assets/images";
  // static const String _svgBase = "assets/svg";

  static const String logo = "$_imagesBase/logos/logo.png";

  // ------------- ONBOARDING -------------
  static const String step1 = "$_imagesBase/step1.jpg";
  static const String step2 = "$_imagesBase/step2.jpg";
  static const String step3 = "$_imagesBase/step3.jpg";

  // ------------- AUTH -------------
  static const String login = "$_imagesBase/login.png";
  static const String register = "$_imagesBase/register.png";
  static const String googleLogo = "$_imagesBase/google.png";

}
