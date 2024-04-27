import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;

import Milestones;

class StatView extends WatchUi.View {

  var title;
  private var subTitleRezName;
  private var iconRezName;

  // Title position
  var titleX;
  var titleY;

  private var centerX;
  private var centerY;

  private var iconResource;
  private var iconDimensions;
  private var iconMaxY;

  private var subTitle;

  function initialize(aTitle, aSubTitle, aIcon) {
    title = aTitle;
    subTitleRezName = aSubTitle;
    iconRezName = aIcon;
    View.initialize();
  }

  function onLayout(dc as Dc) as Void {
    // Calculate scene info
    var width = dc.getWidth();
    var height = dc.getHeight();
    centerX = width / 2;
    centerY = height / 2;

    // Calculate icon position
    var iconSize = 64;
    var iconX = centerX - iconSize / 2;
    var iconY = centerY * 0.3;
    iconMaxY = iconY + iconSize;
    iconDimensions = [iconX, iconY] as Array<Lang.Numeric>;

    // Calculate title position (for subclassing purposes)
    titleX = centerX;
    titleY = iconMaxY;
  }

  // loading resources into memory.
  function onShow() as Void {
    iconResource = WatchUi.loadResource(Rez.Drawables[iconRezName]) as BitmapResource;
    subTitle = WatchUi.loadResource(Rez.Strings[subTitleRezName]) as Lang.String;
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    iconDimensions = iconDimensions as Array<Lang.Numeric>; // What a stupid way to get around the "type system" warning
    dc.drawBitmap(iconDimensions[0], iconDimensions[1], iconResource);

    drawTitle(dc);
    drawSubTitle(dc);
  }

  /**
   * Draws the title of the StatView on the given device context.
   *
   * @param {DeviceContext} dc - The device context to draw on.
   */
  hidden function drawTitle(dc) {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
    dc.drawText(titleX, titleY, Graphics.FONT_NUMBER_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER);
  }

  /**
   * Draws the subtitle of the StatView on the given device context.
   *
   * @param {DeviceContext} dc - The device context to draw on.
   */
  hidden function drawSubTitle(dc) {
    var titleHeight = Graphics.getFontHeight(Graphics.FONT_NUMBER_MEDIUM);
    var y = iconMaxY + titleHeight; // Constrained to title's maxY
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT );
    dc.drawText(centerX, y, Graphics.FONT_SMALL, subTitle, Graphics.TEXT_JUSTIFY_CENTER);
  }

}
