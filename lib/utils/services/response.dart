enum ResponseEnum {
  failed,
  success,
  error,
}

class ResponseType {
  ResponseType({
    required this.responseEnum,
    this.data,
  });

  final ResponseEnum responseEnum;
  var data;
}