import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Milestones;

(:glance)
class App extends Application.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {

  }

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {
  }

  function getGlanceView() {
    return [new GlanceView()];
  }

  // Return the initial view of your application here
  function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
    var stored = Application.Storage.getValue("lastPage");
    var page = stored instanceof Lang.Number ? stored : 0;
    var viewLoop = new WatchUi.ViewLoop(new StatLoopFactory(), {:page => page, :wrap => true});
    return [viewLoop, new NavigationBehavior(viewLoop, page)] as [WatchUi.Views, WatchUi.InputDelegates];
  }

  function onSettingsChanged() as Void {
    WatchUi.requestUpdate();
  }

}

function getApp() as App {
  return Application.getApp() as App;
}
