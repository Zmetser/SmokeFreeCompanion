import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;

import Milestones;
import Settings;

/**
  * A view that displays a stat with an icon and a title.
  * Extend this class to create a new stat view.
  * The View has 4 fields, set them in the onShow function:
  * - title: The title of the stat.
  * - subTitle: The subtitle of the stat.
  * - _iconSimpleId: Drawable resource id for the "Simple" icon style.
  * - _iconPixelId: Drawable resource id for the "Pixel Art" icon style.
  *
  * The icon itself is loaded lazily in onUpdate, since which style to show
  * depends on Settings.getIconStyle() — a Connect-Mobile-pushed setting
  * change only triggers onUpdate, not onShow (see CLAUDE.md "Settings
  * reactivity"). The loaded bitmap is cached and only reloaded when the
  * style actually changes, to avoid reloading it on every tick.
  *
  * @extends WatchUi.View
*/
class StatView extends WatchUi.View {

  // The title of the stat.
  protected var title;

  // The subtitle of the stat.
  protected var subTitle;

  // Icon resource ids for each style — set these in onShow.
  protected var _iconSimpleId as ResourceId?;
  protected var _iconPixelId as ResourceId?;

  // The currently loaded icon bitmap.
  private var iconResource;
  private var _loadedIconStyle as Number?;

  // Title position
  protected var titleX;
  protected var titleY;

  private var _centerX;
  private var _centerY;

  private var _iconDimensions as Array<Lang.Numeric>?;
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

    _updateIconForStyle();

    if (iconResource != null && _iconDimensions != null) {
      dc.drawBitmap(_iconDimensions[0], _iconDimensions[1], iconResource);
    }

    drawTitle(dc);
    drawSubTitle(dc);
  }

  private function _updateIconForStyle() as Void {
    if (_iconSimpleId == null || _iconPixelId == null) {
      return;
    }
    var style = Settings.getIconStyle();
    if (style == _loadedIconStyle) {
      return;
    }
    var id = (style == Settings.ICON_STYLE_PIXEL) ? _iconPixelId : _iconSimpleId;
    iconResource = WatchUi.loadResource(id) as BitmapResource;
    _loadedIconStyle = style;
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
