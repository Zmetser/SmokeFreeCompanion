import Toybox.Application;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;

import Stats;

module Milestones {
  (:glance)
	const MILESTONES = [
    Gregorian.SECONDS_PER_DAY,
    2 * Gregorian.SECONDS_PER_DAY,
    3 * Gregorian.SECONDS_PER_DAY,
    4 * Gregorian.SECONDS_PER_DAY,
    5 * Gregorian.SECONDS_PER_DAY,
    6 * Gregorian.SECONDS_PER_DAY,
    7 * Gregorian.SECONDS_PER_DAY,
    10 * Gregorian.SECONDS_PER_DAY,
    14 * Gregorian.SECONDS_PER_DAY,
    21 * Gregorian.SECONDS_PER_DAY,
    30 * Gregorian.SECONDS_PER_DAY,
    3 * 30 * Gregorian.SECONDS_PER_DAY,
    Gregorian.SECONDS_PER_YEAR / 2,
    Gregorian.SECONDS_PER_YEAR,
    2 * Gregorian.SECONDS_PER_YEAR,
    3 * Gregorian.SECONDS_PER_YEAR,
    4 * Gregorian.SECONDS_PER_YEAR,
    5 * Gregorian.SECONDS_PER_YEAR,
    6 * Gregorian.SECONDS_PER_YEAR,
    7 * Gregorian.SECONDS_PER_YEAR,
    8 * Gregorian.SECONDS_PER_YEAR,
    9 * Gregorian.SECONDS_PER_YEAR,
    10 * Gregorian.SECONDS_PER_YEAR,
    15 * Gregorian.SECONDS_PER_YEAR,
    20 * Gregorian.SECONDS_PER_YEAR,
    25 * Gregorian.SECONDS_PER_YEAR,
    30 * Gregorian.SECONDS_PER_YEAR,
    35 * Gregorian.SECONDS_PER_YEAR,
    40 * Gregorian.SECONDS_PER_YEAR,
    45 * Gregorian.SECONDS_PER_YEAR,
    50 * Gregorian.SECONDS_PER_YEAR
  ] as Array<Lang.Number>;

  (:glance)
  const NUMBER_OF_MILESTONES = MILESTONES.size() as Lang.Number;

  // closest milestone to date in the past
  // should be the first unfulfilled milestone
  (:glance)
  function closestMilestoneTo(moment as Time.Moment) as Lang.Number {
    var today = new Time.Moment(Time.now().value());
    var elapsedTime = Stats.durationSince(moment, today);

    for (var i = 0; i < NUMBER_OF_MILESTONES; i += 1) {
      var milestone = new Time.Duration(MILESTONES[i]);
      if (milestone.compare(elapsedTime) >= 0) {
        return MILESTONES[i];
      }
    }

    return MILESTONES[NUMBER_OF_MILESTONES - 1];
  }

  /**
   * Calculates the progress towards a milestone based on a given moment.
   *
   * @param moment The moment to calculate the progress from.
   * @return The progress towards the milestone as a floating-point number between 0 and 1.
   */
  (:glance)
  function milestoneProgress(moment as Time.Moment) as Lang.Float {
    var today = new Time.Moment(Time.now().value());
    var elapsedTime = Stats.durationSince(moment, today);
    var milestone = closestMilestoneTo(moment);
    var remaining = milestone - elapsedTime.value();

    return 1 - (remaining.toFloat() / milestone.toFloat());
  }
}
