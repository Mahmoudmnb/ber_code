class Constant {
  static const Duration duration = Duration(milliseconds: 500);
  static const String appId = 'JrCsJBb6TbHxnywzrXKXMMqhwLJrZPalm3hlsGxS';
  static const String restApiKey = '1H171HGjMvEeJiZp3Xkayc9ttPU0evvCbLnFBnxw';
  static const Map<String, String> header = {
    'X-Parse-Application-Id': Constant.appId,
    'X-Parse-REST-API-Key': Constant.restApiKey,
    'X-Parse-Revocable-Session': '1',
    'Content-Type': 'application/json'
  };
}
