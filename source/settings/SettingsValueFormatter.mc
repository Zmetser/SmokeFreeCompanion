import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

module SettingsValueFormatter {

  function formatPrice(value as Float, currencyConfig as Lang.Dictionary) as String {
    var formatted = value.format(currencyConfig[:priceFormat] as String);
    var symbol = currencyConfig[:symbol] as String;
    var suffixed = currencyConfig[:suffixed] as Boolean;
    if (suffixed) {
      return formatted + " " + symbol;
    }
    return symbol + formatted;
  }

  function formatQuitDate(moment as Time.Moment, dateFormatTemplate as String) as String {
    var info = Gregorian.info(moment, Time.FORMAT_MEDIUM);
    return Lang.format(dateFormatTemplate, [info.day, info.month, info.year]);
  }

  function combinePrice(intPart as Number, decPart as Number) as Float {
    return intPart.toFloat() + decPart.toFloat() / 100.0f;
  }

  function splitPrice(value as Float) as Array<Number> {
    var intPart = value.toNumber();
    var decPart = ((value - intPart) * 100 + 0.5).toNumber();
    if (decPart >= 100) {
      intPart += 1;
      decPart -= 100;
    }
    return [intPart, decPart] as Array<Number>;
  }

  // Split a 0..9999 integer into [thousands, hundreds, tens, ones].
  function splitIntDigits(value as Number) as Array<Number> {
    var v = value;
    if (v < 0) { v = 0; }
    if (v > 9999) { v = 9999; }
    return [
      (v / 1000) % 10,
      (v / 100) % 10,
      (v / 10) % 10,
      v % 10,
    ] as Array<Number>;
  }

  // Split a Float price into [hundreds, tens, ones, tenths] for prefixed currencies.
  function splitPriceWithTenths(value as Float) as Array<Number> {
    var tenthsTotal = (value * 10 + 0.5).toNumber();
    if (tenthsTotal < 0) { tenthsTotal = 0; }
    if (tenthsTotal > 9999) { tenthsTotal = 9999; }
    return [
      (tenthsTotal / 1000) % 10,
      (tenthsTotal / 100) % 10,
      (tenthsTotal / 10) % 10,
      tenthsTotal % 10,
    ] as Array<Number>;
  }
}
