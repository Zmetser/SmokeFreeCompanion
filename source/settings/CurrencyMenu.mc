import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Settings;

class CurrencyMenu extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({:title => Application.loadResource(Rez.Strings.Currency) as String});

    var labels = [
      Application.loadResource(Rez.Strings.SignUSD) as String,
      Application.loadResource(Rez.Strings.SignEUR) as String,
      Application.loadResource(Rez.Strings.SignHUF) as String,
    ];
    for (var i = 0; i < labels.size(); i++) {
      addItem(new WatchUi.MenuItem(labels[i], null, i, {}));
    }
  }
}

class CurrencyMenuDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item as WatchUi.MenuItem) as Void {
    var newIndex = item.getId() as Number;
    if (newIndex != Settings.getCurrencyIndex()) {
      Settings.setCurrencyIndex(newIndex);
      // Pack price scales with currency (e.g. ~$9 vs ~2100 HUF). Reset to the
      // per-currency default so the user isn't left with a nonsensical price
      // — they can adjust if needed.
      var defaultPrice = Settings.getCurrencyConfig()[:defaultPrice] as Float;
      Settings.setPackPrice(defaultPrice);
    }
    WatchUi.popView(WatchUi.SLIDE_RIGHT);
  }
}
