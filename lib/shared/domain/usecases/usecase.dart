abstract class Usecase<T, Param> {
  Future<T> call(Param p);
}

// Pour les données suivies en temps réel (snapshots Firestore).
abstract class StreamUsecase<T, Param> {
  Stream<T> call(Param p);
}

class NoParam {}
