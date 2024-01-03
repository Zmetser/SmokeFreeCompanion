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
      :year   => 2023,
      :month  => 12,
      :day    => 21,
      :hour   => 18,
    });
    cigarettesPerDay = 10;
    packPrice = 2020;
    cigarettesPerPack = 19;
    currency = "HUF";
  }

}
