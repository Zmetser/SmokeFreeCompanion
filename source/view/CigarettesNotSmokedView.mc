import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

import Stats;

class CigarettesNotSmokedView extends StatView {
  function initialize() {
    StatView.initialize();
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();

    iconResource = WatchUi.loadResource(Rez.Drawables.CigarettesNotSmokedIcon) as BitmapResource;
    subTitle = WatchUi.loadResource(Rez.Strings.Cigarettes) as Lang.String;

    var cigs = Stats.cigarettesNotSmoked(
      Settings.getQuitDate(),
      new Time.Moment(Time.now().value()),
      Settings.getCigarettesPerDay()
    );

    title = cigs.format("%u");
  }
}
