sealed class CustomException implements Exception {
  CustomException([this.message]);
  final String? message;

  @override
  String toString() {
    return message.toString();
  }
}

class NetworkException extends CustomException {}

class ServerException extends CustomException {}

class UnauthenticatedException extends CustomException {}

class NotRelayAgentException extends CustomException {}

class TicketNotFoundException extends CustomException {}

class TicketAlreadyProcessedException extends CustomException {}

class TicketExpiredException extends CustomException {}
