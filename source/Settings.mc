import Toybox.System;
import Toybox.Time.Gregorian;
import Toybox.Lang;

(:glance)
class Settings {

  var quitDate;
  var cigarettesPerDay;
  var packPrice;
  var cigarettesPerPack;
  var currency;

  public function initialize() {
    quitDate = Time.Gregorian.moment({
      :year   => 2024,
      :month  => 2,
      :day    => 29,
      :hour   => 21,
    });
    cigarettesPerDay = 7;
    packPrice = 2020;
    cigarettesPerPack = 19;
    currency = "HUF";
  }

}
