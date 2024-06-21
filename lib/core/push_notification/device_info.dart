import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';

class DeviceInfo extends Equatable {
  final String fingerprint;
  final String type;
  final String name;
  final String appVersion;
  final String pushToken;

  const DeviceInfo({
    required this.fingerprint,
    required this.type,
    required this.name,
    required this.appVersion,
    required this.pushToken,
  });

  factory DeviceInfo.fromIosDeviceInfo(
      IosDeviceInfo iosDeviceInfo, String pushToken) {
    return DeviceInfo(
      fingerprint: iosDeviceInfo.identifierForVendor ?? '',
      type: iosDeviceInfo.model,
      name: iosDeviceInfo.name,
      appVersion: iosDeviceInfo.systemVersion,
      pushToken: pushToken,
    );
  }

  factory DeviceInfo.fromAndroidDeviceInfo(
      AndroidDeviceInfo androidDeviceInfo, String pushToken) {
    return DeviceInfo(
      fingerprint: androidDeviceInfo.fingerprint,
      type: androidDeviceInfo.model,
      name: androidDeviceInfo.brand,
      appVersion: androidDeviceInfo.version.release,
      pushToken: pushToken,
    );
  }

  @override
  List<Object?> get props => [
        fingerprint,
        type,
        name,
        appVersion,
        pushToken,
      ];
}
