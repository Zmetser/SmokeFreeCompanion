import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;

import Settings;
import Stats;

class MoneyNotSpentView extends StatView {
  private var _currencyConfig as Lang.Dictionary?;

  private const _titleFont = Graphics.FONT_NUMBER_MEDIUM;
  private const _currencyFont = Graphics.FONT_MEDIUM;
  // Space between title and currency symbol
  private const _space = 3;

  function initialize() {
    StatView.initialize();
  }

  function onShow() as Void {
    StatView.onShow();

    iconResource = WatchUi.loadResource(Rez.Drawables.MoneyNotSpentIcon) as BitmapResource;
    subTitle = WatchUi.loadResource(Rez.Strings.Saved) as Lang.String;
  }

  function onUpdate(dc as Dc) as Void {
    _currencyConfig = Settings.getCurrencyConfig();

    var packs = Stats.packsNotBought(
      Settings.getQuitDate(),
      new Time.Moment(Time.now().value()),
      Settings.getCigarettesPerDay(),
      Settings.getPackSize()
    );

    var price = packs * Settings.getPackPrice();
    title = price.format((_currencyConfig as Lang.Dictionary)[:priceFormat] as String);

    StatView.onUpdate(dc);
  }

  // Override to add currency symbol to title
  function drawTitle(dc as Dc) as Void {
    var symbol = (_currencyConfig as Lang.Dictionary)[:symbol] as String;
    var currencyX = getCurrencyX(dc, symbol);
    var currencyY = titleY + Graphics.getFontAscent(_titleFont) - Graphics.getFontAscent(_currencyFont);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(titleX, titleY, _titleFont, title, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(currencyX, currencyY, _currencyFont, symbol, Graphics.TEXT_JUSTIFY_RIGHT);
  }

  function getCurrencyX(dc as Dc, symbol as String) as Number {
    var titleW = dc.getTextWidthInPixels(title, _titleFont) as Number;
    var suffixed = (_currencyConfig as Lang.Dictionary)[:suffixed] as Boolean;

    if (suffixed) {
      var currencyW = dc.getTextWidthInPixels(symbol, _currencyFont) as Number;
      return titleX + (titleW / 2) + _space + currencyW;
    } else {
      return titleX - (titleW / 2) - _space;
    }
  }
}
