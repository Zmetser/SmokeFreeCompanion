import Stats;

class CigarettesNotSmokedView extends StatView {
  function initialize() {
    StatView.initialize(
      "9999",
      :Cigarettes,
      :CigaretteCrossed
    );
  }
}
