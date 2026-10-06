abstract class Usecase<T, Param> {
  Future<T> call(Param p);
}

class NoParam {}
