import Toybox.Lang;
import Stats;

class MoneyNotSpentView extends StatView {
  var currencySymbol;
  var settings;

  function initialize(aSettings) {
    StatView.initialize(
      "100.000",
      :Saved,
      :Money
    );
    settings = aSettings;
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();
    currencySymbol = settings.getCurrencySymbol();
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

