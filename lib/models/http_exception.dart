class HttpException implements Exception {
  // When we implement a class : we are signing a contract
  // we HAVE to implement all the methods of the class
  //
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
