import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Milestones;

(:glance)
class QuitTrackerApp extends Application.AppBase {

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
    return [ new QuitTrackerGlanceView() ];
  }

  // Return the initial view of your application here
  function getInitialView() as Array<Views or InputDelegates>? {
    return [ new CigarettesNotSmokedView(), new StatsBehavior() ] as Array<Views or InputDelegates>;
  }

}

function getApp() as QuitTrackerApp {
  return Application.getApp() as QuitTrackerApp;
}
