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
    28 * Gregorian.SECONDS_PER_DAY,
    30 * Gregorian.SECONDS_PER_DAY,
    3 * 30 * Gregorian.SECONDS_PER_DAY,
    Gregorian.SECONDS_PER_YEAR / 2,
    Gregorian.SECONDS_PER_YEAR
  ] as Array<Lang.Number>;

  (:glance)
  const NUMBER_OF_MILESTONES = MILESTONES.size() as Lang.Number;

  // TODO: Figure out how to handle infinite years
  function milestoneToString(milestone as Lang.Number) as String {
    // Hiding const here to not confuse :glance with the Rez object.
    // TODO: Figure out a better separation of :glance
    var INDEX_TO_MILESTONE_SYMBOL = [
      Rez.Strings.m0,
      Rez.Strings.m1,
      Rez.Strings.m2,
      Rez.Strings.m3,
      Rez.Strings.m4,
      Rez.Strings.m5,
      Rez.Strings.m6,
      Rez.Strings.m7,
      Rez.Strings.m8,
      Rez.Strings.m9,
      Rez.Strings.m10,
      Rez.Strings.m11,
      Rez.Strings.m12,
      Rez.Strings.m13,
      Rez.Strings.m14,
    ] as Array<Lang.Symbol>;
    var index = MILESTONES.indexOf(milestone);
    if (index != -1) {
      return Application.loadResource(INDEX_TO_MILESTONE_SYMBOL[index]);
    }
    return Application.loadResource(Rez.Strings.m14);
  }

  // closest milestone to date in the past
  // should be the first unfulfilled milestone
  // TODO: Test all the cases
  // TODO: Figure out how to handle infinite years
  (:glance)
  function closestMilestoneTo(moment as Time.Moment) as Lang.Number {
    var elapsedTime = Stats.durationSince(moment);

    for (var i = 0; i < NUMBER_OF_MILESTONES; i += 1) {
      var milestone = new Time.Duration(MILESTONES[i]);
      if (milestone.greaterThan(elapsedTime)) {
        return MILESTONES[i];
      }
    }

    return MILESTONES[NUMBER_OF_MILESTONES - 1];
  }

  (:glance)
  function milestoneProgress(moment as Time.Moment) as Lang.Float {
    var elapsedTime = Stats.durationSince(moment);
    var milestone = closestMilestoneTo(moment);
    var remaining = milestone - elapsedTime.value();

    return 1 - (remaining.toFloat() / milestone.toFloat());
  }
}
