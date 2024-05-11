import Toybox.System;
import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

module Settings {

  public function getPackPrice() as Number {
    return Properties.getValue("packPrice");
  }

  public function getPackSize() as Number {
    return Properties.getValue("packSize");
  }

  public function getCigarettesPerDay() as Number {
    return Properties.getValue("cigarettesPerDay");
  }

  (:glance)
  public function getQuitDate() as Time.Moment {
    var timestamp = Properties.getValue("quitDate");
    // If the quit date is not set or is in the future, return today
    if (timestamp == 0 || timestamp > Time.now().value()) {
      return new Time.Moment(Time.today().value());
    }

    return new Time.Moment(timestamp);
  }

  public function getCurrencySymbol() as String {
    var currencyIndex = Properties.getValue("currency");
    if (currencyIndex >= 0 && currencyIndex < currencySymbols.size()) {
      var id = (currencySymbols as Array<Lang.Symbol>)[currencyIndex];
      return Application.loadResource(Rez.Strings[id]);
    }

    return Application.loadResource(Rez.Strings.SignUSD);
  }

  var currencySymbols = [
    :SignUSD,
    :SignEUR,
    :SignHUF
  ] as Array<Lang.Symbol>;
}
