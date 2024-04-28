import Toybox.WatchUi;
import Toybox.Lang;

class StatsBehavior extends BehaviorDelegate {

  private static var currentPage as Number = 0;
  private static var numberOfViews as Number = 2;

  function initialize() {
    BehaviorDelegate.initialize();
  }

  // Detect Menu behavior
  function onMenu() as Boolean {
    System.println("Menu behavior triggered");
    return false; // allow InputDelegate function to be called
  }

  function onNextPage() as Boolean {
    System.println("onNextPage");
    currentPage = (currentPage + 1) % numberOfViews;
    var view = getView(currentPage);

    WatchUi.switchToView(view, new StatsBehavior(), WatchUi.SLIDE_UP);

    return true;
  }

  function onPreviousPage() as Boolean {
    System.println("onPreviousPage");
    currentPage = (currentPage - 1) < 0 ? numberOfViews - 1 : currentPage - 1;
    var view = getView(currentPage);

    WatchUi.switchToView(view, new StatsBehavior(), WatchUi.SLIDE_DOWN);

    return true;
  }

  function getView(page as Number) as View {
    switch (page) {
      case 0: return new CigarettesNotSmokedView();
      case 1: return new MoneyNotSpentView();
      default: return new CigarettesNotSmokedView();
    }
  }
}