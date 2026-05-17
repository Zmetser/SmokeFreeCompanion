import Toybox.Test;
import Toybox.Time;
import Toybox.Lang;
import Toybox.Application;

import Settings;

(:test)
module SettingsTests {

  // Test-only helper. Lives in this (:test) module so the wrapped seam stays
  // out of production builds, and the test runner doesn't try to invoke it
  // as a test (it isn't (:test)-annotated and doesn't take a Logger).
  function _setReader(r as PropertyReader) as Void {
    Settings._reader = r;
  }

  (:test)
  function quitDate_returnsTodayWhenZero(logger as Logger) as Boolean {
    _setReader(new DictPropertyReader({"quitDate" => 0}));
    var got = Settings.getQuitDate();
    return got.value() == Time.today().value();
  }

  (:test)
  function quitDate_returnsTodayWhenInFuture(logger as Logger) as Boolean {
    var future = Time.now().value() + 86400;
    _setReader(new DictPropertyReader({"quitDate" => future}));
    var got = Settings.getQuitDate();
    return got.value() == Time.today().value();
  }

  (:test)
  function quitDate_returnsStoredWhenPast(logger as Logger) as Boolean {
    var past = Time.now().value() - 86400;
    _setReader(new DictPropertyReader({"quitDate" => past}));
    var got = Settings.getQuitDate();
    return got.value() == past;
  }

  (:test)
  function currencySymbol_outOfRangeFallsBackToUSD(logger as Logger) as Boolean {
    _setReader(new DictPropertyReader({"currency" => 99}));
    var got = Settings.getCurrencyConfig();
    var expected = Application.loadResource(Rez.Strings.SignUSD) as String;
    return got[:symbol].equals(expected);
  }

  (:test)
  function currencySymbol_eachIndexReturnsExpectedResource(logger as Logger) as Boolean {
    var keys = [Rez.Strings.SignUSD, Rez.Strings.SignEUR, Rez.Strings.SignHUF];
    for (var i = 0; i < keys.size(); i++) {
      _setReader(new DictPropertyReader({"currency" => i}));
      var got = Settings.getCurrencyConfig();
      var expected = Application.loadResource(keys[i]) as String;
      if (!got[:symbol].equals(expected)) {
        logger.debug(Lang.format("Currency $1$: expected '$2$', got '$3$'.", [i, expected, got[:symbol]]));
        return false;
      }
    }
    return true;
  }
}
