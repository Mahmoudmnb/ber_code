import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class InternetInfo {
  InternetConnectionCheckerPlus netInfo;
  InternetInfo({required this.netInfo});
  Future<bool> get isconnected;
}

class InternetInfoImp implements InternetInfo {
  @override
  InternetConnectionCheckerPlus netInfo;
  @override
  Future<bool> get isconnected async {
    return await netInfo.hasConnection;
  }

  InternetInfoImp({required this.netInfo});
}
