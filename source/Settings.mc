import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

module Settings {

  public function getPackPrice() as Float {
    var v = Properties.getValue("packPrice");
    return v != null ? (v as Float) : 9.0f;
  }

  public function getPackSize() as Number {
    var v = Properties.getValue("packSize");
    return v != null ? (v as Number) : 19;
  }

  public function getCigarettesPerDay() as Number {
    var v = Properties.getValue("cigarettesPerDay");
    return v != null ? (v as Number) : 1;
  }

  public function getCurrencyIndex() as Number {
    var v = Properties.getValue("currency");
    return v != null ? (v as Number) : 0;
  }

  public function getColorSpace() as Number {
    var v = Properties.getValue("colorSpace");
    return v != null ? (v as Number) : 0;
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
