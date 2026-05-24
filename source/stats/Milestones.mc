import Toybox.Application;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;

import Stats;

module Milestones {
  (:glance)
  const MILESTONES = [
    20 * 60,                              // 20min
    8 * Gregorian.SECONDS_PER_HOUR,       // 8h
    Gregorian.SECONDS_PER_DAY,            // 24h
    2 * Gregorian.SECONDS_PER_DAY,        // 48h
    3 * Gregorian.SECONDS_PER_DAY,        // 72h
    7 * Gregorian.SECONDS_PER_DAY,        // 1w
    14 * Gregorian.SECONDS_PER_DAY,       // 2w
    28 * Gregorian.SECONDS_PER_DAY,       // 4w
    84 * Gregorian.SECONDS_PER_DAY,       // 12w
    6 * 30 * Gregorian.SECONDS_PER_DAY,   // 6mo
    9 * 30 * Gregorian.SECONDS_PER_DAY,   // 9mo
    Gregorian.SECONDS_PER_YEAR            // 1y
  ] as Array<Lang.Number>;

  (:glance)
  const NUMBER_OF_MILESTONES = MILESTONES.size() as Lang.Number;

  // closest milestone to date in the past
  // should be the first unfulfilled milestone
  (:glance)
  function closestMilestoneTo(moment as Time.Moment, today as Time.Moment) as Lang.Number {
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
  function milestoneProgress(moment as Time.Moment, today as Time.Moment) as Lang.Float {
    var elapsedTime = Stats.durationSince(moment, today);

    if (elapsedTime.value() >= MILESTONES[NUMBER_OF_MILESTONES - 1]) {
      return 1.0;
    }

    var milestone = closestMilestoneTo(moment, today);
    var remaining = milestone - elapsedTime.value();

    return 1 - (remaining.toFloat() / milestone.toFloat());
  }

  // Maps a target milestone to one of 8 NHS description bands.
  // 0:20min  1:8h  2:24h  3:48h  4:72h  5:weeks(1-12w)  6:months(6-9mo)  7:1y+
  function bandIndexFor(targetSeconds as Lang.Number) as Lang.Number {
    if (targetSeconds <= 20 * 60)                          { return 0; }
    if (targetSeconds <= 8 * Gregorian.SECONDS_PER_HOUR)   { return 1; }
    if (targetSeconds <= Gregorian.SECONDS_PER_DAY)        { return 2; }
    if (targetSeconds <= 2 * Gregorian.SECONDS_PER_DAY)    { return 3; }
    if (targetSeconds <= 3 * Gregorian.SECONDS_PER_DAY)    { return 4; }
    if (targetSeconds < 90 * Gregorian.SECONDS_PER_DAY)    { return 5; }
    if (targetSeconds < Gregorian.SECONDS_PER_YEAR)        { return 6; }
    return 7;
  }

  // Picks the elapsed-display divisor: one tier finer than the target's label.
  // Sub-hour targets render elapsed in minutes; sub-week in hours; else days.
  // So "5min / 20min", "23h / 48h", and "260d / 1y" all read naturally.
  function elapsedDivisorFor(targetSeconds as Lang.Number) as Lang.Number {
    if (targetSeconds < Gregorian.SECONDS_PER_HOUR)     { return 60; }
    if (targetSeconds < 7 * Gregorian.SECONDS_PER_DAY)  { return Gregorian.SECONDS_PER_HOUR; }
    return Gregorian.SECONDS_PER_DAY;
  }

  function elapsedUnitFor(targetSeconds as Lang.Number, units as Lang.Dictionary) as Lang.String {
    if (targetSeconds < Gregorian.SECONDS_PER_HOUR)     { return units[:minute]; }
    if (targetSeconds < 7 * Gregorian.SECONDS_PER_DAY)  { return units[:hour]; }
    return units[:day];
  }

  // Formats a milestone duration in its natural unit. Bucket boundaries:
  //   < 1 hour  → minutes  (20min)
  //   < 7 days  → hours    (8h, 24h, 48h, 72h)
  //   < 90 days → weeks    (1w..12w)
  //   < 1 year  → months   (6mo, 9mo)
  //   ≥ 1 year  → years    (1y, 2y, …)
  // `units` is a dict keyed by :minute :hour :day :week :month :year (loaded from resources).
  function labelFor(seconds as Lang.Number, units as Lang.Dictionary) as Lang.String {
    if (seconds >= Gregorian.SECONDS_PER_YEAR) {
      return (seconds / Gregorian.SECONDS_PER_YEAR).toString() + units[:year];
    }
    var monthSeconds = 30 * Gregorian.SECONDS_PER_DAY;
    if (seconds >= 90 * Gregorian.SECONDS_PER_DAY) {
      return (seconds / monthSeconds).toString() + units[:month];
    }
    if (seconds >= 7 * Gregorian.SECONDS_PER_DAY) {
      return (seconds / (7 * Gregorian.SECONDS_PER_DAY)).toString() + units[:week];
    }
    if (seconds >= Gregorian.SECONDS_PER_HOUR) {
      return (seconds / Gregorian.SECONDS_PER_HOUR).toString() + units[:hour];
    }
    return (seconds / 60).toString() + units[:minute];
  }
}
