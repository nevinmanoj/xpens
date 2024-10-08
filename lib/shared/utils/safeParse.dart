double safeDoubleParse(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    return 0.0;
  }
}
