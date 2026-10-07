// Texte stocké en { "fr": "...", "en": "..." } ou en simple chaîne.
// Repli sur le français, puis sur la première langue disponible.
String localizedField(Object? value, String localeName) {
  if (value is String) return value;
  if (value is Map) {
    final lang = localeName.split("_").first;
    final text = value[lang] ?? value["fr"] ?? value.values.firstOrNull;
    return text is String ? text : "";
  }
  return "";
}
