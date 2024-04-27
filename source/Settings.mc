import Toybox.System;
import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

(:glance)
class Settings {

  var cigarettesPerDay;
  var packPrice;
  var cigarettesPerPack;

  public function initialize() {
    cigarettesPerDay = 7;
    packPrice = 2020;
    cigarettesPerPack = 19;
  }

  public function getQuitDate() as Time.Moment {
    System.println(Properties.getValue("quitDate"));
    var timestamp = Properties.getValue("quitDate");
    if (timestamp > 0) {
      return new Time.Moment(timestamp);
    }
    return new Time.Moment(Time.today().value());
  }

  public function getCurrencySymbol() as String {
    var currencyIndex = Properties.getValue("currency");
    if (currencyIndex >= 0 && currencyIndex < currencySymbols.size()) {
      var id = currencySymbols[currencyIndex];
      return Application.loadResource(Rez.Strings[id]);
    }

    return Application.loadResource(Rez.Strings.SignUSD);
  }

  private static var currencySymbols = [
    :SignUSD,
    :SignEUR,
    :SignHUF
  ] as Array<Lang.Symbol>;
}
