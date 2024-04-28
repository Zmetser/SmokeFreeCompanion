import Stats;

class CigarettesNotSmokedView extends StatView {
  function initialize() {
    StatView.initialize(
      :Cigarettes,
      :CigaretteCrossed
    );
  }

  // loading resources into memory.
  function onShow() as Void {
    StatView.onShow();
    var cigs = Stats.cigarettesNotSmoked(
      Settings.getQuitDate(),
      new Time.Moment(Time.today().value()),
      Settings.getCigarettesPerDay()
    );

    title = cigs.format("%u");
  }
}
