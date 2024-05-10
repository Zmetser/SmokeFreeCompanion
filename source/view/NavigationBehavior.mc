import Toybox.WatchUi;
import Toybox.Lang;

class NavigationBehavior extends BehaviorDelegate {
  // Private variable to store the current page number.
  private var _currentPage as Number;
  private const _numberOfViews as Number = 2;

  /**
   * Initializes the NavigationBehavior object with the specified current page number.
   * @param currentPage The current page number.
   */
  function initialize(currentPage as Number) {
    _currentPage = currentPage;
    BehaviorDelegate.initialize();
  }

  /**
   * Switches to the next page and updates the view accordingly.
   * @return True if the operation is successful, false otherwise.
   */
  function onNextPage() as Boolean {
    var nextPage = (_currentPage + 1) % _numberOfViews;
    var view = getView(nextPage);

    WatchUi.switchToView(view, new NavigationBehavior(nextPage), WatchUi.SLIDE_UP);

    return true;
  }

  /**
   * Switches to the previous page and updates the view accordingly.
   * @return True if the operation is successful, false otherwise.
   */
  function onPreviousPage() as Boolean {
    var prevPage = (_currentPage - 1) < 0 ? _numberOfViews - 1 : _currentPage - 1;
    var view = getView(prevPage);

    WatchUi.switchToView(view, new NavigationBehavior(prevPage), WatchUi.SLIDE_DOWN);

    return true;
  }

  /**
   * Returns the view corresponding to the specified page number.
   * @param page The page number.
   * @return The view object.
   */
  function getView(page as Number) as View {
    switch (page) {
      case 0: return new CigarettesNotSmokedView();
      case 1: return new MoneyNotSpentView();
      default: return new CigarettesNotSmokedView();
    }
  }
}
