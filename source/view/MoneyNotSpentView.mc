import Toybox.Application;
import Toybox.Lang;
import Toybox.Time;

import Settings;
import Stats;

class MoneyNotSpentView extends StatView {
  var currencySymbol;

  function initialize() {
    StatView.initialize(
      :Saved,
      :Money
    );
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();
    currencySymbol = Settings.getCurrencySymbol();
    var packs = Stats.packsNotBought(
      Settings.getQuitDate(),
      new Time.Moment(Time.today().value()),
      Settings.getCigarettesPerDay(),
      Settings.getPackSize()
    );

    var price = packs * Settings.getPackPrice();
    System.println(packs + "*" + Settings.getPackPrice() + "=" + price);

    var currencyIndex = Properties.getValue("currency");
    if (currencyIndex == 2) { // HUF doesn't need decimal places
      title = price.format("%u");
    } else {
      title = price.format("%.1f");
    }
  }

  // Override to add currency symbol to title
  hidden function drawTitle(dc) {
    var titleDimensions = dc.getTextDimensions(title, Graphics.FONT_NUMBER_MEDIUM) as Array<Lang.Number>;
    var space = dc.getTextDimensions("w", Graphics.FONT_MEDIUM) as Array<Lang.Number>;
    var titleW = titleDimensions[0];
    var currencyX = titleX - (titleW / 2) - space[0];
    var currencyY = titleY + space[1] / 2;

    dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
    dc.drawText(titleX, titleY, Graphics.FONT_NUMBER_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(currencyX, currencyY, Graphics.FONT_MEDIUM, currencySymbol, Graphics.TEXT_JUSTIFY_LEFT);
  }
}

