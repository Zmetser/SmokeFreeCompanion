import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Math;

import Milestones;

module MilestonesTests {

  var today = new Time.Moment(Time.now().value());

  const TEST_UNITS = {
    :hour => "h",
    :day => "d",
    :week => "w",
    :month => "mo",
    :year => "y",
  };

  (:test)
  function canGet24hMilestone(logger as Logger) {
    var duration = new Time.Duration((0.5 * Gregorian.SECONDS_PER_DAY) as Lang.Number);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime, today);
    return TestUtils.verifyValueEquals(logger, milestone, Gregorian.SECONDS_PER_DAY);
  }

  (:test)
  function canGet48hMilestone(logger as Logger) {
    var duration = new Time.Duration(Gregorian.SECONDS_PER_DAY + 1);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime, today);
    return TestUtils.verifyValueEquals(logger, milestone, 2 * Gregorian.SECONDS_PER_DAY);
  }

  (:test)
  function canGet1WeekMilestone(logger as Logger) {
    var duration = new Time.Duration(6 * Gregorian.SECONDS_PER_DAY + 1);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime, today);
    return TestUtils.verifyValueEquals(logger, milestone, 7 * Gregorian.SECONDS_PER_DAY);
  }

  (:test)
  function canGet12WeekMilestone(logger as Logger) {
    var duration = new Time.Duration(60 * Gregorian.SECONDS_PER_DAY);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime, today);
    return TestUtils.verifyValueEquals(logger, milestone, 84 * Gregorian.SECONDS_PER_DAY);
  }

  (:test)
  function canGet6MonthMilestone(logger as Logger) {
    var duration = new Time.Duration(100 * Gregorian.SECONDS_PER_DAY);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime, today);
    return TestUtils.verifyValueEquals(logger, milestone, 6 * 30 * Gregorian.SECONDS_PER_DAY);
  }

  (:test)
  function canGetProgress(logger as Logger) {
    var duration = new Time.Duration((0.5 * Gregorian.SECONDS_PER_DAY) as Lang.Number);
    var quitTime = today.subtract(duration) as Time.Moment;
    var progress = Milestones.milestoneProgress(quitTime, today);

    return (Math.round(progress * 10) / 10 == 0.5);
  }

  (:test)
  function progressPastLastMilestone(logger as Logger) {
    var twoYears = new Time.Duration(2 * Gregorian.SECONDS_PER_YEAR);
    var quitTime = today.subtract(twoYears) as Time.Moment;
    var progress = Milestones.milestoneProgress(quitTime, today);
    return TestUtils.verifyValueEquals(logger, progress, 1.0);
  }

  (:test)
  function labelFor24h(logger as Logger) {
    var label = Milestones.labelFor(Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "24h");
  }

  (:test)
  function labelFor48h(logger as Logger) {
    var label = Milestones.labelFor(2 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "48h");
  }

  (:test)
  function labelFor1Week(logger as Logger) {
    var label = Milestones.labelFor(7 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "1w");
  }

  (:test)
  function labelFor12Weeks(logger as Logger) {
    var label = Milestones.labelFor(84 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "12w");
  }

  (:test)
  function labelFor6Months(logger as Logger) {
    var label = Milestones.labelFor(6 * 30 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "6mo");
  }

  (:test)
  function labelFor1Year(logger as Logger) {
    var label = Milestones.labelFor(Gregorian.SECONDS_PER_YEAR, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, label, "1y");
  }

  (:test)
  function labelForCoversEveryMilestone(logger as Logger) {
    var expected = ["24h", "48h", "72h", "1w", "2w", "4w", "12w", "6mo", "9mo", "1y"];
    if (Milestones.NUMBER_OF_MILESTONES != expected.size()) {
      logger.debug("MILESTONES size " + Milestones.NUMBER_OF_MILESTONES + " != expected " + expected.size());
      return false;
    }
    for (var i = 0; i < Milestones.NUMBER_OF_MILESTONES; i++) {
      var label = Milestones.labelFor(Milestones.MILESTONES[i], TEST_UNITS);
      if (!label.equals(expected[i])) {
        logger.debug("MILESTONES[" + i + "] labeled " + label + ", expected " + expected[i]);
        return false;
      }
    }
    return true;
  }

  (:test)
  function elapsedUnitForHourTargets(logger as Logger) {
    var unit = Milestones.elapsedUnitFor(2 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, unit, "h");
  }

  (:test)
  function elapsedUnitForWeekTargets(logger as Logger) {
    var unit = Milestones.elapsedUnitFor(7 * Gregorian.SECONDS_PER_DAY, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, unit, "d");
  }

  (:test)
  function elapsedUnitForYearTargets(logger as Logger) {
    var unit = Milestones.elapsedUnitFor(Gregorian.SECONDS_PER_YEAR, TEST_UNITS);
    return TestUtils.verifyValueEquals(logger, unit, "d");
  }

  (:test)
  function bandIndexForMapsEachMilestone(logger as Logger) {
    // index in MILESTONES → expected band
    var expected = [0, 1, 2, 3, 3, 3, 3, 4, 4, 5];
    if (Milestones.NUMBER_OF_MILESTONES != expected.size()) {
      logger.debug("MILESTONES size " + Milestones.NUMBER_OF_MILESTONES + " != expected " + expected.size());
      return false;
    }
    for (var i = 0; i < Milestones.NUMBER_OF_MILESTONES; i++) {
      var band = Milestones.bandIndexFor(Milestones.MILESTONES[i]);
      if (band != expected[i]) {
        logger.debug("MILESTONES[" + i + "] band=" + band + ", expected " + expected[i]);
        return false;
      }
    }
    return true;
  }

  (:test)
  function bandIndexForPastFinalMilestone(logger as Logger) {
    var band = Milestones.bandIndexFor(2 * Gregorian.SECONDS_PER_YEAR);
    return TestUtils.verifyValueEquals(logger, band, 5);
  }

  (:test)
  function exactMilestoneHasToBeHundredPercent(logger as Logger) {
    for (var i = 0; i < Milestones.NUMBER_OF_MILESTONES; i++) {
      var milestone = Milestones.MILESTONES[i];
      var duration = new Time.Duration(milestone);
      var quitTime = today.subtract(duration) as Time.Moment;
      var progress = Milestones.milestoneProgress(quitTime, today);

      if (progress < 1.0) {
        logger.debug("Milestone[" + i + "]: " + milestone);
        logger.debug("Progress: " + progress);
        return false;
      }
    }
    return true;
  }
}
