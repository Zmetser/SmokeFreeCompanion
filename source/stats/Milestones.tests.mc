import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Math;

import Milestones;

module MilestonesTests {

  var today = new Time.Moment(Time.now().value());

  (:test)
  function canGetOneDayMilestone(logger as Logger) {
    var duration = new Time.Duration((0.5 * Gregorian.SECONDS_PER_DAY) as Lang.Number);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[0]);
  }

  (:test)
  function canGetTwoDayMilestone(logger as Logger) {
    var duration = new Time.Duration(Gregorian.SECONDS_PER_DAY + 1);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[1]);
  }

  (:test)
  function canGetOneWeekMilestone(logger as Logger) {
    var duration = new Time.Duration(6 * Gregorian.SECONDS_PER_DAY + 1);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[6]);
  }

  (:test)
  function canGetTwoWeekMilestone(logger as Logger) {
    var duration = new Time.Duration(11 * Gregorian.SECONDS_PER_DAY);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[8]);
  }

  (:test)
  function canGetThreeMonthsMilestone(logger as Logger) {
    var duration = new Time.Duration(2 * 30 * Gregorian.SECONDS_PER_DAY);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[11]);
  }

  (:test)
  function canGetProgress(logger as Logger) {
    var duration = new Time.Duration((0.5 * Gregorian.SECONDS_PER_DAY) as Lang.Number);
    var quitTime = today.subtract(duration) as Time.Moment;
    var progress = Milestones.milestoneProgress(quitTime);

    return (Math.round(progress * 10) / 10 == 0.5);
  }

  (:test)
  function exactMilestoneHasToBeHundredPercent(logger as Logger) {
    for (var i = 0; i < Milestones.NUMBER_OF_MILESTONES; i++) {
      var milestone = Milestones.MILESTONES[i];
      var duration = new Time.Duration(milestone);
      var quitTime = today.subtract(duration) as Time.Moment;
      var progress = Milestones.milestoneProgress(quitTime);

      if (progress < 1.0) {
        logger.debug("Milestone[" + i + "]: " + milestone);
        logger.debug("Progress: " + progress);
        return false;
      }
    }
    return true;
  }
}
