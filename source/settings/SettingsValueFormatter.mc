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
}
