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
    var currentIndex = Settings.getCurrencyIndex();
    for (var i = 0; i < labels.size(); i++) {
      var subLabel = (i == currentIndex) ? "✓" : null;
      addItem(new WatchUi.MenuItem(labels[i], subLabel, i, {}));
    }
  }
}

class CurrencyMenuDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item as WatchUi.MenuItem) as Void {
    Settings.setCurrencyIndex(item.getId() as Number);
    WatchUi.popView(WatchUi.SLIDE_RIGHT);
  }
}
