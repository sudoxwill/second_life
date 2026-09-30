/// Chemins d'assets Dogbale.
///
/// Les fichiers ne sont pas encore présents — chaque constante attend qu'un
/// asset réel soit déposé dans `assets/images/` et déclaré dans `pubspec.yaml`.
class AppAssets {
  AppAssets._();

  static const String _imagesBase = "assets/images";
  static const String _svgBase = "assets/svg";

  static const String logo = "$_imagesBase/logos/logo.png";

  // ------------- ONBOARDING -------------
  // static const String exemple = "$_imagesBase/exemple.jpg";
  static const String exempleSvg = "$_svgBase/exemple.svg";
}
