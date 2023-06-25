import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class CircularProgressBar extends WatchUi.Drawable {

  var colorBase as Graphics.ColorType;
  var colorActive as Graphics.ColorType;
  var value = 0 as Lang.Float; // [0-1]

  var start = 220;
  var end = 320;

  typedef CircularProgressBarSettings as {
    :colorBase as Graphics.ColorType,
    :colorActive as Graphics.ColorType
  };
  function initialize(settings as CircularProgressBarSettings) {
    self.colorBase = settings[ :colorBase ] as Graphics.ColorType;
    self.colorActive = settings[ :colorActive ] as Graphics.ColorType;
    Drawable.initialize(settings);
  }

  function setValue(value as Lang.Float) {
    self.value = value;
  }

  hidden function progress(radius as Lang.Double) as Lang.Double {
    var centralAngle = 360 - (start - end).abs(); // 260
    var arcLength = (centralAngle / 360.0) * 2 * Math.PI * radius as Lang.Double;
    var progressAngle = (arcLength * (1 - value) * 360.0) / (2 * Math.PI * radius) as Lang.Double; // Angle between 0 and 260, we need to rotate this to between [220-320]
    return progressAngle;
  }

  function draw(dc as Graphics.Dc) {
    var xMid = dc.getWidth() / 2;
    var yMid = dc.getHeight() / 2;
    var radius = xMid - 4 as Lang.Double;

    if (dc has :setAntiAlias) {
        dc.setAntiAlias(true);
    }
    dc.setPenWidth(8);

    dc.setColor(colorBase, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(xMid, yMid, radius, Graphics.ARC_CLOCKWISE, start, end);

    dc.setColor(colorActive, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(xMid, yMid, radius, Graphics.ARC_CLOCKWISE, start, end - (360 - progress(radius)));
  }
}
