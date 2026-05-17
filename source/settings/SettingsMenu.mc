import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Settings;
import SettingsValueFormatter;

class SettingsMenu extends WatchUi.Menu2 {
  private var _quitDateItem as WatchUi.MenuItem?;
  private var _cigsPerDayItem as WatchUi.MenuItem?;
  private var _currencyItem as WatchUi.MenuItem?;
  private var _packPriceItem as WatchUi.MenuItem?;
  private var _packSizeItem as WatchUi.MenuItem?;

  function initialize() {
    Menu2.initialize({:title => Application.loadResource(Rez.Strings.SettingsMenuTitle) as String});

    _quitDateItem = new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.QuitDate) as String,
      _quitDateSubLabel(),
      :quitDate,
      {}
    );
    _cigsPerDayItem = new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.CigarettesPerDay) as String,
      Settings.getCigarettesPerDay().toString(),
      :cigarettesPerDay,
      {}
    );
    _currencyItem = new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.Currency) as String,
      Settings.getCurrencyConfig()[:symbol] as String,
      :currency,
      {}
    );
    _packPriceItem = new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.PackPrice) as String,
      SettingsValueFormatter.formatPrice(Settings.getPackPrice(), Settings.getCurrencyConfig()),
      :packPrice,
      {}
    );
    _packSizeItem = new WatchUi.MenuItem(
      Application.loadResource(Rez.Strings.PackSize) as String,
      Settings.getPackSize().toString(),
      :packSize,
      {}
    );

    addItem(_quitDateItem);
    addItem(_cigsPerDayItem);
    addItem(_currencyItem);
    addItem(_packPriceItem);
    addItem(_packSizeItem);
  }

  function onShow() as Void {
    Menu2.onShow();
    _refreshSubLabels();
  }

  private function _refreshSubLabels() as Void {
    if (_quitDateItem != null) {
      (_quitDateItem as WatchUi.MenuItem).setSubLabel(_quitDateSubLabel());
    }
    if (_cigsPerDayItem != null) {
      (_cigsPerDayItem as WatchUi.MenuItem).setSubLabel(Settings.getCigarettesPerDay().toString());
    }
    if (_currencyItem != null) {
      (_currencyItem as WatchUi.MenuItem).setSubLabel(Settings.getCurrencyConfig()[:symbol] as String);
    }
    if (_packPriceItem != null) {
      (_packPriceItem as WatchUi.MenuItem).setSubLabel(
        SettingsValueFormatter.formatPrice(Settings.getPackPrice(), Settings.getCurrencyConfig())
      );
    }
    if (_packSizeItem != null) {
      (_packSizeItem as WatchUi.MenuItem).setSubLabel(Settings.getPackSize().toString());
    }
    WatchUi.requestUpdate();
  }

  private function _quitDateSubLabel() as String {
    return SettingsValueFormatter.formatQuitDate(
      Settings.getQuitDate(),
      Application.loadResource(Rez.Strings.DateFormat) as String
    );
  }
}

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item as WatchUi.MenuItem) as Void {
    var id = item.getId();
    if (id == :quitDate) {
      WatchUi.pushView(
        new DatePicker(
          Application.loadResource(Rez.Strings.QuitDate) as String,
          Settings.getQuitDate()
        ),
        new QuitDatePickerDelegate(),
        WatchUi.SLIDE_LEFT
      );
    } else if (id == :cigarettesPerDay) {
      WatchUi.pushView(
        new WholeNumberPicker(
          Application.loadResource(Rez.Strings.CigarettesPerDay) as String,
          1, 100, Settings.getCigarettesPerDay()
        ),
        new CigarettesPerDayPickerDelegate(),
        WatchUi.SLIDE_LEFT
      );
    } else if (id == :currency) {
      WatchUi.pushView(new CurrencyMenu(), new CurrencyMenuDelegate(), WatchUi.SLIDE_LEFT);
    } else if (id == :packPrice) {
      WatchUi.pushView(
        new PricePicker(
          Application.loadResource(Rez.Strings.PackPrice) as String,
          Settings.getPackPrice()
        ),
        new PackPricePickerDelegate(),
        WatchUi.SLIDE_LEFT
      );
    } else if (id == :packSize) {
      WatchUi.pushView(
        new WholeNumberPicker(
          Application.loadResource(Rez.Strings.PackSize) as String,
          1, 100, Settings.getPackSize()
        ),
        new PackSizePickerDelegate(),
        WatchUi.SLIDE_LEFT
      );
    }
  }

  function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    WatchUi.requestUpdate();
  }
}
