class Status {
  final String location;
  final int code;
  final String url;
  final double temp_f;
  final double temp_c;

  Status(this.location, this.code, this.url, this.temp_f, this.temp_c) {
    if (location == null) {
      throw ArgumentError("login of Status cannot be null. "
          "Received: '$location'");
    }

    if (url == null) {
      throw ArgumentError("avatarUrl of Status cannot be null. "
          "Received: '$url'");
    }
  }
}
