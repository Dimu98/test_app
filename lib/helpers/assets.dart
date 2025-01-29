
abstract class Assets {
  const Assets._();

  static _Icon get icon => const _Icon();
  static _Image get image => const _Image();
}

abstract class _AssetsHolder {
  final String basePath;

  const _AssetsHolder(this.basePath);
}

class _Icon extends _AssetsHolder {
  const _Icon() : super("assets/icons");

  String get dark => "$basePath/dark.svg";
  String get logoout => "$basePath/logoout.svg";
  String get og => "$basePath/og.svg";
  String get time => "$basePath/time.svg";

}

class _Image extends _AssetsHolder {
  const _Image() : super("assets/images");


}
