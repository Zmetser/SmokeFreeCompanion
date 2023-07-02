import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Lang;

import Stats;
import Milestones;

class QuitTrackerView extends WatchUi.View {

  var settings;

  var g_XMid;
  var g_YMid;

  function initialize(aSettings) {
    settings = aSettings;
    View.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    g_XMid = dc.getWidth() / 2;
    g_YMid = dc.getHeight() / 2;

    setLayout(Rez.Layouts.MainLayout(dc));
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

    var closestMilestone = Milestones.closestMilestoneTo(settings.quitDate);
    var milestoneLabel = View.findDrawableById("field3") as Text;
    milestoneLabel.setText(Milestones.milestoneToString(closestMilestone));

    var progress = Milestones.milestoneProgress(settings.quitDate) as Lang.Float;
    var milestonePercentageLabel = View.findDrawableById("field1") as Text;
    milestonePercentageLabel.setText(Math.round(progress * 100).format("%d") + "%");

    // TODO: smoke free since
    // TODO: money saved, cigarettes not smoked

    var steps = View.findDrawableById("progressBar") as CircularProgressBar;
    steps.setValue(progress);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {
  }

}
