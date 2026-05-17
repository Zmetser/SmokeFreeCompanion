import Toybox.Test;
import Toybox.Lang;
import Toybox.Time;

import SettingsValueFormatter;

(:test)
module SettingsValueFormatterTests {

  (:test)
  function formatPrice_prefixed(logger as Logger) as Boolean {
    var config = { :symbol => "$", :suffixed => false, :priceFormat => "%.1f" };
    return SettingsValueFormatter.formatPrice(9.0f, config).equals("$9.0");
  }

  (:test)
  function formatPrice_suffixed(logger as Logger) as Boolean {
    var config = { :symbol => "Ft", :suffixed => true, :priceFormat => "%u" };
    return SettingsValueFormatter.formatPrice(2100.0f, config).equals("2100 Ft");
  }

  (:test)
  function combinePrice_basic(logger as Logger) as Boolean {
    return SettingsValueFormatter.combinePrice(12, 50) == 12.5f;
  }

  (:test)
  function splitPrice_basic(logger as Logger) as Boolean {
    var parts = SettingsValueFormatter.splitPrice(12.5f);
    return parts[0] == 12 && parts[1] == 50;
  }

  (:test)
  function splitPrice_roundsUpOnBoundary(logger as Logger) as Boolean {
    var parts = SettingsValueFormatter.splitPrice(12.999f);
    return parts[0] == 13 && parts[1] == 0;
  }

  (:test)
  function formatQuitDate_englishOrder(logger as Logger) as Boolean {
    var moment = new Time.Moment(Time.today().value());
    var got = SettingsValueFormatter.formatQuitDate(moment, "$1$ $2$ $3$");
    return got != null && (got as String).length() > 0;
  }
}
