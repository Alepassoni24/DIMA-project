class Utils {

  // Truncate a double to int if it does not have a decimal part
  static String truncateDouble(double value) {
    return value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }
}
