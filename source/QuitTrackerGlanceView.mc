import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;
import Toybox.Application;

import Milestones;
import Stats;

(:glance)
class QuitTrackerGlanceView extends WatchUi.GlanceView {

  var settings;
  var appName;

  function initialize(aSettings) {
    settings = aSettings;
    GlanceView.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    appName = Application.loadResource( Rez.Strings.AppNameGlance );
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
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

    // Milestone progress
    var progress = Milestones.milestoneProgress(settings.quitDate) as Lang.Float;
    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(maxX * progress, height / 2, maxX, height / 2);
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(4);
    dc.drawLine(minX, height / 2, maxX * progress - 1, height / 2);
    dc.setPenWidth(1);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    // App name
    dc.drawText(
            minX,
            minY,
            Graphics.FONT_GLANCE,
            appName,
            Graphics.TEXT_JUSTIFY_LEFT);

    // Elapsed since quit
    var elapsedSinceQuit = Stats.formatDuration(Stats.elapsedSince(settings.quitDate), true);
    dc.drawText(
            minX,
            maxY,
            Graphics.FONT_GLANCE,
            elapsedSinceQuit,
            Graphics.TEXT_JUSTIFY_LEFT);

    dc.drawText(
            maxX,
            maxY,
            Graphics.FONT_GLANCE,
            Math.round(progress * 100).format("%d") + "%",
            Graphics.TEXT_JUSTIFY_RIGHT);

    // Left from milestone %
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {
  }

}
