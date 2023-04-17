abstract class Failer {}

class ServerFailer implements Failer {
  final String errorMessage;
  ServerFailer({required this.errorMessage});
}

class WrongData extends Failer {}

class NoInternet extends Failer {}
