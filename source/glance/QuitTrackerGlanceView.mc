import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;
import Toybox.Application;

import Milestones;
import Settings;
import Stats;

(:glance)
class QuitTrackerGlanceView extends WatchUi.GlanceView {

  var quitDate;
  private var _appName;

  private const GROUP_SPACING = 4;
  private const UNIT_SPACING = 0;

  // fonts
  private const _unitFont as FontDefinition = Graphics.FONT_TINY;
  private const _dataFont as FontDefinition = Graphics.FONT_GLANCE_NUMBER;
  private var _dataFontAscent as Number = 0;
  private var _unitFontAscent as Number = 0;


  function initialize() {
    GlanceView.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    _appName = Application.loadResource( Rez.Strings.AppNameGlance );
    _dataFontAscent = Graphics.getFontAscent(_dataFont);
    _unitFontAscent = Graphics.getFontAscent(_unitFont);
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    quitDate = Settings.getQuitDate() as Time.Moment;
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    var height = dc.getHeight();
    var width = dc.getWidth();

    var minX = width * 0.02;
    var maxX = width * 0.95;
    var minY = height * 0.06;
    var maxY = height * 0.57;
    var usableWidth = maxX - minX;

    // Milestone progress
    // =====|-- Draws the foreground, leaves a gap and from there it draws the remaining background
    var progress = Milestones.milestoneProgress(quitDate) as Lang.Float;
    var progressW = maxX * progress;
    // progress foreground
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(7);
    dc.drawLine(minX, height / 2, progressW, height / 2);
    // progress background
    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(3);
    dc.drawLine(minX + progressW + 3, height / 2, maxX, height / 2);

    // Reset
    dc.setPenWidth(1);
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    // App name
    dc.drawText(
            minX,
            minY,
            Graphics.FONT_GLANCE,
            _appName,
            Graphics.TEXT_JUSTIFY_LEFT);

    // Elapsed since quit and progress
    var progressReadable = Math.round(progress * 100).format("%d") + "%";
    dc.drawText( maxX, maxY, _dataFont, progressReadable, Graphics.TEXT_JUSTIFY_RIGHT);

    drawElapsedTime(dc, minX, maxY, usableWidth - (dc.getTextWidthInPixels(progressReadable, _dataFont) + UNIT_SPACING));
  }

  function drawElapsedTime(dc as Dc, startX as Float, y as Float, maxWidth as Float) as Void {
    var today = new Time.Moment(Time.now().value());
    var elapsedSinceQuit = Stats.elapsedTimeSince(quitDate, today);
    var x = startX;
    var unitY = y + _dataFontAscent - _unitFontAscent; // baseline for unit

    var keys = [:years, :months, :days, :hours, :minutes];
    var units = ["y", "m", "d", "h", "m"];

    for (var i = 0; i < elapsedSinceQuit.size(); i += 1) {
      var unit = units[i];
      var data = elapsedSinceQuit.get(keys[i]);

      if (data > 0 || x != startX) { // start drawing from the first non-zero value
        var dataWidth = dc.getTextWidthInPixels(data.toString(), _dataFont) + UNIT_SPACING;
        var unitWidth = dc.getTextWidthInPixels(unit, _unitFont) + GROUP_SPACING;
        // Stop drawign if the rest of the text won't fit the maxWidth
        if ((x + dataWidth + unitWidth) >= maxWidth) { return; }

        // Draw data and unit
        dc.drawText(x, y, _dataFont, data.toString(), Graphics.TEXT_JUSTIFY_LEFT);
        x += dataWidth;
        dc.drawText(x, unitY, _unitFont, unit, Graphics.TEXT_JUSTIFY_LEFT);
        x += unitWidth;
      }
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {
  }

}
