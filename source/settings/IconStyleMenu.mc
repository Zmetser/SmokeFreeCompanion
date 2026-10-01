import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Settings;

class IconStyleMenu extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({:title => Application.loadResource(Rez.Strings.IconStyle) as String});

    addItem(new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.IconStyleSimple) as String,
      null, Settings.ICON_STYLE_SIMPLE, {}
    ));
    addItem(new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.IconStylePixel) as String,
      null, Settings.ICON_STYLE_PIXEL, {}
    ));
  }
}

class IconStyleMenuDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item as WatchUi.MenuItem) as Void {
    Settings.setIconStyle(item.getId() as Number);
    WatchUi.popView(WatchUi.SLIDE_RIGHT);
  }
}
