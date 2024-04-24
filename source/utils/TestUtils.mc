// https://forums.garmin.com/developer/connect-iq/f/discussion/167651/storage-querk
import Toybox.Test;
import Toybox.Lang;

(:test)
module TestUtils {
  /**
   * Compares two dictionaries and verifies if they are equal.
   *
   * @param logger The logger object used for debugging.
   * @param a The first dictionary to compare.
   * @param b The second dictionary to compare.
   * @return True if the dictionaries are equal, false otherwise.
   */
  function verifyDictEquals(logger as Logger, a, b) as Boolean {
    var a_sz = a.size();
    var b_sz = b.size();
    if (a_sz != b_sz) {
      return false;
    }

    var keys = a.keys() as Array<Lang.Any>;
    for (var i = 0; i < a_sz; ++i) {
      var key = keys[i];

      if (!verifyValueEquals(logger, a[key], b[key])) {
        logger.debug(a);
        logger.debug(Lang.format("Expected '$1$', got '$2$' at '$3$'.", [a[key], b[key], key]));
        return false;
      }
    }

    return true;
  }

  /**
   * Compares two arrays and verifies if they are equal.
   *
   * @param logger The logger object used for debugging.
   * @param a The first array to compare.
   * @param b The second array to compare.
   * @return True if the arrays are equal, false otherwise.
   */
  function verifyArrayEquals(logger as Logger, a as Array<Lang.Any>, b as Array<Lang.Any>) as Boolean {
    var a_sz = a.size();
    var b_sz = b.size();
    if (a_sz != b_sz) {
      return false;
    }

    for (var i = 0; i < a_sz; ++i) {
      if (!verifyValueEquals(logger, a[i], b[i])) {
        logger.debug(i.toString());
        logger.debug(Lang.format("Expected '$1$', got '$2$'.", [ a[i], b[i] ]));
        return false;
      }
    }

    return true;
  }

  /**
   * Compares two values and returns true if they are equal, false otherwise.
   *
   * @param logger The logger object used for logging.
   * @param a The first value to compare.
   * @param b The second value to compare.
   * @return True if the values are equal, false otherwise.
   */
  function verifyValueEquals(logger as Logger, a, b) as Boolean {
    if ((a instanceof Lang.Dictionary) && (b instanceof Lang.Dictionary)) {
      return verifyDictEquals(logger, a, b);
    }
    if ((a instanceof Lang.Array) && (b instanceof Lang.Array)) {
      return verifyArrayEquals(logger, a, b);
    }
    if ((a instanceof Lang.String) && (b instanceof Lang.String)) {
      return a.equals(b);
    }
    if ((a instanceof Lang.Double) && (b instanceof Lang.Double)) {
      return abs(b - a) < 0.001;
    }
    if ((a instanceof Lang.Float) && (b instanceof Lang.Float)) {
      return abs(b - a) < 0.001;
    }
    if ((a instanceof Lang.Long) && (b instanceof Lang.Long)) {
      return a == b;
    }
    if ((a instanceof Lang.Number) && (b instanceof Lang.Number)) {
      return a == b;
    }
    if ((a instanceof Lang.Boolean) && (b instanceof Lang.Boolean)) {
      return a == b;
    }
    return false;
  }

}
