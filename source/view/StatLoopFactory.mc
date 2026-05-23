import Toybox.Lang;
import Toybox.WatchUi;

// Provides the three stat views to the WatchUi.ViewLoop, which then draws
// the native page indicator on the left bezel and handles transitions.
// Garmin reconstructs the view each time you navigate, so views must not
// hold session state across navigations — ours read everything fresh from
// Settings in onUpdate, so re-construction is cheap.
class StatLoopFactory extends WatchUi.ViewLoopFactory {
  public const NUM_PAGES as Number = 3;

  function initialize() {
    ViewLoopFactory.initialize();
  }

  function getView(page as Number) {
    return [_viewForPage(page), new WatchUi.BehaviorDelegate()];
  }

  function getSize() as Number {
    return NUM_PAGES;
  }

  private function _viewForPage(page as Number) as WatchUi.View {
    switch (page) {
      case 0: return new CigarettesNotSmokedView();
      case 1: return new MoneyNotSpentView();
      case 2: return new CleanSinceView();
      default: return new CigarettesNotSmokedView();
    }
  }
}
