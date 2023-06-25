import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Math;

import Milestones;

module MilestonesTests {

  var today = new Time.Moment(Time.now().value());

  (:test)
  function canGetDayString(logger as Logger) {
    var duration = 10 * Gregorian.SECONDS_PER_DAY;
    return "10 Days".equals(Milestones.milestoneToString(duration));
  }

  (:test)
  function canGetOneDayMilestone(logger as Logger) {
    var duration = new Time.Duration((0.5 * Gregorian.SECONDS_PER_DAY) as Lang.Number);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[0]);
  }

  (:test)
  function canGetTwoDayMilestone(logger as Logger) {
    var duration = new Time.Duration(Gregorian.SECONDS_PER_DAY);
    var quitTime = today.subtract(duration) as Time.Moment;
    var milestone = Milestones.closestMilestoneTo(quitTime);
    return (milestone == Milestones.MILESTONES[1]);
  }

  (:test)
  function canGetOneWeekMilestone(logger as Logger) {
    var duration = new Time.Duration(6 * Gregorian.SECONDS_PER_DAY);
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
}
