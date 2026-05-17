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
    var nav = new NavigationBehavior(0);
    return [nav.getView(0), nav] as [WatchUi.Views, WatchUi.InputDelegates];
  }

  function onSettingsChanged() as Void {
    WatchUi.requestUpdate();
  }

}

function getApp() as App {
  return Application.getApp() as App;
}
