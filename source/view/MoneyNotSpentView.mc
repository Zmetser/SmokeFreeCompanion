import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;

import Settings;
import Stats;

class MoneyNotSpentView extends StatView {
  private var _currencySymbol;

  private const _titleFont = Graphics.FONT_NUMBER_MEDIUM;
  private const _currencyFont = Graphics.FONT_MEDIUM;
  // Space between title and currency symbol
  private const _space = 3;

  function initialize() {
    StatView.initialize();
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();

    iconResource = WatchUi.loadResource(Rez.Drawables.MoneyNotSpentIcon) as BitmapResource;
    subTitle = WatchUi.loadResource(Rez.Strings.Saved) as Lang.String;

    _currencySymbol = Settings.getCurrencySymbol();
    var packs = Stats.packsNotBought(
      Settings.getQuitDate(),
      new Time.Moment(Time.now().value()),
      Settings.getCigarettesPerDay(),
      Settings.getPackSize()
    );

    var price = packs * Settings.getPackPrice();

    var currencyIndex = Properties.getValue("currency");
    if (currencyIndex == 2) { // HUF doesn't need decimal places
      title = price.format("%u");
    } else {
      title = price.format("%.1f");
    }
  }

  // Override to add currency symbol to title
  function drawTitle(dc as Dc) as Void {
    var currencyX = getCurrencyX(dc);
    var currencyY = titleY + Graphics.getFontAscent(_titleFont) - Graphics.getFontAscent(_currencyFont);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(titleX, titleY, _titleFont, title, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(currencyX, currencyY, _currencyFont, _currencySymbol, Graphics.TEXT_JUSTIFY_RIGHT);
  }

  function getCurrencyX(dc as Dc) as Number {
    var titleW = dc.getTextWidthInPixels(title, _titleFont) as Number;
    var currencyIndex = Properties.getValue("currency");

    if (currencyIndex == 2) { // HUF is suffixed
      var currencyW = dc.getTextWidthInPixels(_currencySymbol, _currencyFont) as Number;
      return titleX + (titleW / 2) + _space + currencyW;
    } else {
      return titleX - (titleW / 2) - _space;
    }
  }
}
