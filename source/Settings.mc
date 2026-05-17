import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

module Settings {

  var _reader as PropertyReader? = null;

  (:glance)
  function _getReader() as PropertyReader {
    if (_reader == null) {
      _reader = new ApplicationPropertyReader();
    }
    return _reader;
  }

  public function getPackPrice() as Float {
    var v = _getReader().getValue("packPrice");
    return v != null ? (v as Float) : 9.0f;
  }

  public function getPackSize() as Number {
    var v = _getReader().getValue("packSize");
    return v != null ? (v as Number) : 19;
  }

  public function getCigarettesPerDay() as Number {
    var v = _getReader().getValue("cigarettesPerDay");
    return v != null ? (v as Number) : 1;
  }

  public function getCurrencyIndex() as Number {
    var v = _getReader().getValue("currency");
    return v != null ? (v as Number) : 0;
  }

  (:glance)
  public function getColorSpace() as Number {
    var v = _getReader().getValue("colorSpace");
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
    var raw = _getReader().getValue("quitDate");
    if (!(raw instanceof Lang.Number)) {
      return new Time.Moment(Time.today().value());
    }
    var timestamp = raw as Number;
    if (timestamp == 0 || timestamp > Time.now().value()) {
      return new Time.Moment(Time.today().value());
    }
    return new Time.Moment(timestamp);
  }

  public function setQuitDate(moment as Time.Moment) as Void {
    _getReader().setValue("quitDate", moment.value());
  }

  public function setCigarettesPerDay(value as Number) as Void {
    _getReader().setValue("cigarettesPerDay", value);
  }

  public function setCurrencyIndex(value as Number) as Void {
    _getReader().setValue("currency", value);
  }

  public function setPackPrice(value as Float) as Void {
    _getReader().setValue("packPrice", value);
  }

  public function setPackSize(value as Number) as Void {
    _getReader().setValue("packSize", value);
  }
}
