import Stats;
import Toybox.Lang;

class MoneyNotSpentView extends StatView {
  function initialize() {
    StatView.initialize(
      "100.000",
      :Saved,
      :Money
    );
  }

  // Override to add currency symbol to title
  hidden function drawTitle(dc) {
    var currency = "Ft";
    var titleDimensions = dc.getTextDimensions(title, Graphics.FONT_NUMBER_MEDIUM) as Array<Lang.Number>;
    var space = dc.getTextDimensions("w", Graphics.FONT_MEDIUM) as Array<Lang.Number>;
    var titleW = titleDimensions[0];
    var currencyX = titleX - (titleW / 2) - space[0];
    var currencyY = titleY + space[1] / 2;

    dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
    dc.drawText(titleX, titleY, Graphics.FONT_NUMBER_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(currencyX, currencyY, Graphics.FONT_MEDIUM, currency, Graphics.TEXT_JUSTIFY_LEFT);
  }
}
