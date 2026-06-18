import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Outer delegate for the page-loop ViewLoop. Handles MENU (push settings)
// and persists the last-viewed page on every navigation.
class NavigationBehavior extends WatchUi.ViewLoopDelegate {
  private var _viewLoop as WatchUi.ViewLoop;
  private var _currentPage as Number;
  private const _numberOfViews as Number = 3;

  function initialize(viewLoop as WatchUi.ViewLoop, currentPage as Number) {
    ViewLoopDelegate.initialize(viewLoop);
    _viewLoop = viewLoop;
    _currentPage = currentPage;
  }

  function onNextView() as Boolean {
    _viewLoop.changeView(WatchUi.ViewLoop.DIRECTION_NEXT);
    _currentPage = (_currentPage + 1) % _numberOfViews;
    Storage.setValue("lastPage", _currentPage);
    return true;
  }

  function onPreviousView() as Boolean {
    _viewLoop.changeView(WatchUi.ViewLoop.DIRECTION_PREVIOUS);
    _currentPage = (_currentPage - 1 + _numberOfViews) % _numberOfViews;
    Storage.setValue("lastPage", _currentPage);
    return true;
  }

  function onMenu() as Boolean {
    WatchUi.pushView(new SettingsMenu(), new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
    return true;
  }
}
