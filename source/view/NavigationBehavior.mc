import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Lang;

class NavigationBehavior extends BehaviorDelegate {
  private var _currentPage as Number;
  private const _numberOfViews as Number = 3;

  function initialize(currentPage as Number) {
    _currentPage = currentPage;
    Storage.setValue("lastPage", currentPage);
    BehaviorDelegate.initialize();
  }

  function onNextPage() as Boolean {
    var nextPage = (_currentPage + 1) % _numberOfViews;
    WatchUi.switchToView(getView(nextPage), new NavigationBehavior(nextPage), WatchUi.SLIDE_UP);
    return true;
  }

  function onPreviousPage() as Boolean {
    var prevPage = (_currentPage - 1 + _numberOfViews) % _numberOfViews;
    WatchUi.switchToView(getView(prevPage), new NavigationBehavior(prevPage), WatchUi.SLIDE_DOWN);
    return true;
  }

  function onMenu() as Boolean {
    WatchUi.pushView(new SettingsMenu(), new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
    return true;
  }

  // To add a view: add a case here and increment _numberOfViews.
  function getView(page as Number) as WatchUi.View {
    switch (page) {
      case 0: return new CigarettesNotSmokedView();
      case 1: return new MoneyNotSpentView();
      case 2: return new CleanSinceView();
      default: return new CigarettesNotSmokedView();
    }
  }
}
