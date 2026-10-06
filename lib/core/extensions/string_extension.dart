import "dart:convert";
import "dart:ui" show Color;

extension StringExtensions on String {
  // Validation
  bool get isEmail {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(this);
  }

  bool get isUrl {
    final urlRegex = RegExp(
      r"^https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b",
    );
    return urlRegex.hasMatch(this);
  }

  bool get isPhone {
    final phoneRegex = RegExp(r"^\+?[\d\s-()]+$");
    return phoneRegex.hasMatch(this) && length >= 10;
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isAlphabetic {
    final alphabeticRegex = RegExp(r"^[a-zA-Z]+$");
    return alphabeticRegex.hasMatch(this);
  }

  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r"^[a-zA-Z0-9]+$");
    return alphanumericRegex.hasMatch(this);
  }

  // Transformations
  String get capitalize {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get capitalizeWords {
    if (isEmpty) {
      return this;
    }
    return split(" ").map((word) => word.capitalize).join(" ");
  }

  String get camelCase {
    final words = split(RegExp(r"[\s_-]+"));
    if (words.isEmpty) {
      return this;
    }
    return words.first.toLowerCase() +
        words.skip(1).map((word) => word.capitalize).join();
  }

  String get snakeCase {
    return replaceAllMapped(
      RegExp("[A-Z]"),
          (match) => "_${match.group(0)!.toLowerCase()}",
    ).replaceFirst(RegExp("^_"), "");
  }

  String get kebabCase {
    return replaceAllMapped(
      RegExp("[A-Z]"),
          (match) => "-${match.group(0)!.toLowerCase()}",
    ).replaceFirst(RegExp("^-"), "");
  }

  // Truncation
  String truncate(int maxLength, {String suffix = "..."}) {
    if (length <= maxLength) {
      return this;
    }
    return "${substring(0, maxLength - suffix.length)}$suffix";
  }

  String truncateWords(int maxWords, {String suffix = "..."}) {
    final words = split(" ");
    if (words.length <= maxWords) {
      return this;
    }
    return '${words.take(maxWords).join(' ')}$suffix';
  }

  // Checks
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => trim().isNotEmpty;

  // Removal
  String removeWhitespace() => replaceAll(RegExp(r"\s+"), "");
  String removeSpecialCharacters() => replaceAll(RegExp(r"[^\w\s]"), "");

  // Masking
  String maskEmail() {
    if (!isEmail) {
      return this;
    }
    final parts = split("@");
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    }

    return '${username[0]}${'*' * (username.length - 2)}${username
    [username.length - 1]}@$domain';
  }

  String maskPhone() {
    if (length < 4) {
      return this;
    }
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }

  // Parsing
  int? toInt() => int.tryParse(this);
  double? toDouble() => double.tryParse(this);
  DateTime? toDateTime() => DateTime.tryParse(this);

  // Encoding/Decoding
  String toBase64() {
    return base64.encode(utf8.encode(this));
  }

  String fromBase64() {
    return utf8.decode(base64.decode(this));
  }

  Color toColor() {
    var cleanHex = replaceAll("#", "").replaceAll("0x", "");
    if (cleanHex.length == 6) {
      cleanHex = "FF$cleanHex";
    }
    return Color(int.parse(cleanHex, radix: 16));
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNullOrBlank => this == null || this!.isBlank;

  String get orEmpty => this ?? "";
  String orDefault(String defaultValue) => this ?? defaultValue;
}

extension UrlStringExtensions on String {
  String get urlSafe => Uri.encodeComponent(this);
}
