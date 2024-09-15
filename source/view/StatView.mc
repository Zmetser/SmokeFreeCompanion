import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;

import Milestones;

/**
  * A view that displays a stat with an icon and a title.
  * Extend this class to create a new stat view.
  * The View has 3 fields, set them in the onShow function:
  * - title: The title of the stat.
  * - subTitle: The subtitle of the stat.
  * - iconResource: The icon to display.
  *
  * @extends WatchUi.View
*/
class StatView extends WatchUi.View {

  // The title of the stat.
  protected var title;

  // The subtitle of the stat.
  protected var subTitle;

  // The icon to display.
  protected var iconResource;

  // Title position
  protected var titleX;
  protected var titleY;

  private var _centerX;
  private var _centerY;

  private var _iconDimensions;
  private var _iconMaxY;

  function initialize() {
    View.initialize();
  }

  function onLayout(dc as Dc) as Void {
    // Calculate scene info
    var width = dc.getWidth();
    var height = dc.getHeight();
    _centerX = width / 2;
    _centerY = height / 2;

    // Calculate icon position
    var iconSize = 64;
    var iconX = _centerX - iconSize / 2;
    var iconY = _centerY * 0.3;
    _iconMaxY = iconY + iconSize;
    _iconDimensions = [iconX, iconY] as Array<Lang.Numeric>;

    // Calculate title position (for subclassing purposes)
    titleX = _centerX;
    titleY = _iconMaxY;
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    if (iconResource != null) {
      _iconDimensions = _iconDimensions as Array<Lang.Numeric>; // What a stupid way to get around the "type system" warning
      dc.drawBitmap(_iconDimensions[0], _iconDimensions[1], iconResource);
    }

    drawTitle(dc);
    drawSubTitle(dc);
  }

  /**
   * Draws the title of the StatView on the given device context.
   *
   * @param {DeviceContext} dc - The device context to draw on.
   */
  protected function drawTitle(dc as Dc) as Void {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
    dc.drawText(titleX, titleY, Graphics.FONT_NUMBER_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER);
  }

  /**
   * Draws the subtitle of the StatView on the given device context.
   *
   * @param {DeviceContext} dc - The device context to draw on.
   */
  protected function drawSubTitle(dc as Dc) as Void {
    var titleHeight = Graphics.getFontHeight(Graphics.FONT_NUMBER_MEDIUM);
    var y = _iconMaxY + titleHeight; // Constrained to title's maxY
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT );
    dc.drawText(_centerX, y, Graphics.FONT_SMALL, subTitle, Graphics.TEXT_JUSTIFY_CENTER);
  }
}
