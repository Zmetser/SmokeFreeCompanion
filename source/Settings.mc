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

  (:glance)
  public function getColorSpace() as Number {
    var v = Properties.getValue("colorSpace");
    return v != null ? (v as Number) : 0;
  }

  public function getCurrencyConfig() as Lang.Dictionary {
    var configs = [
      { :symbol => Application.loadResource(Rez.Strings.SignUSD) as String, :suffixed => false, :priceFormat => "%.1f" },
      { :symbol => Application.loadResource(Rez.Strings.SignEUR) as String, :suffixed => false, :priceFormat => "%.1f" },
      { :symbol => Application.loadResource(Rez.Strings.SignHUF) as String, :suffixed => true,  :priceFormat => "%u"   },
    ] as Array<Lang.Dictionary>;
    var index = getCurrencyIndex();
    return configs[index < configs.size() ? index : 0];
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
}
