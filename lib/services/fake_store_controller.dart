import 'package:upgrader/upgrader.dart';

class FakeStoreController extends UpgraderStoreController {
  @override
  Future<UpgraderVersionInfo?> getVersionInfo() async {
    return UpgraderVersionInfo(
      appStoreVersion: Version.parse("5.0.0"),     // fake new version
      installedVersion: "1.0.2",
      minAppVersion: "3.0.0",       // force update scenario
      releaseNotes: "Testing upgrade flow",
      appStoreListingURL: "https://play.google.com/store/apps/details?id=com.app.selavu",
    );
  }
}