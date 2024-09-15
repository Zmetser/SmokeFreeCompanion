import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

import Stats;

class CleanSinceView extends StatView {
  private var _oneDayTitle as String?;
  private var _oneDaySubTitle as String?;
  private var _subTitle as String?;
  private var _dateFormat as String?;
  
  function initialize() {
    StatView.initialize();
  }
  
  function onLayout(dc as Dc) as Void {
    StatView.onLayout(dc);
    
    _oneDayTitle = Application.loadResource( Rez.Strings.Quit_OneDayTitle );
    _oneDaySubTitle = Application.loadResource( Rez.Strings.Quit_OneDaySubtitle );
    _subTitle = Application.loadResource( Rez.Strings.Quit_QuitDate );
    _dateFormat = Application.loadResource( Rez.Strings.DateFormat );
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();

    iconResource = WatchUi.loadResource(Rez.Drawables.QuitDateIcon) as BitmapResource;
    subTitle = _subTitle;
    
    var quitDate = Settings.getQuitDate();
    var now = new Time.Moment(Time.today().value());
    
    if (now.subtract(quitDate).value() < Gregorian.SECONDS_PER_DAY) {
      title = _oneDayTitle;
      subTitle = _oneDaySubTitle;
    } else {
      var quitDateInfo = Gregorian.info(quitDate, Time.FORMAT_MEDIUM);
      var dateString = Lang.format(
        _dateFormat,
        [
          quitDateInfo.day,
          quitDateInfo.month,
          quitDateInfo.year
        ]
      );
      title = dateString;
    }
  }
  
  function drawTitle(dc as Dc) as Void {
    var titleHeight = Graphics.getFontHeight(Graphics.FONT_MEDIUM);
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
    dc.drawText(titleX, titleY + titleHeight / 2, Graphics.FONT_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER);
  }
}
