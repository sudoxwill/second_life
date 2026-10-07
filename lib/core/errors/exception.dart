sealed class CustomException implements Exception {
  const CustomException([this.message]);
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

class UsernameTakenException extends CustomException {
  const UsernameTakenException() : super("Username already taken");
}

class SignInCancelledException extends CustomException {
  const SignInCancelledException() : super("Sign-in cancelled");
}

class TicketNotFoundException extends CustomException {}

class TicketAlreadyProcessedException extends CustomException {}

class TicketExpiredException extends CustomException {}
