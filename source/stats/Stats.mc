import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

module Stats {
  const DAYS_IN_MONTH = 365 / 12;

  var dHour = Gregorian.SECONDS_PER_HOUR;
  var dDay = Gregorian.SECONDS_PER_DAY;
  var dMonth = DAYS_IN_MONTH * Gregorian.SECONDS_PER_DAY;

  /**
   * Calculates the duration between the quit date and today.
   *
   * @param quitDate The quit date as a Time.Moment object.
   * @param today The current date as a Time.Moment object.
   * @return The duration between the quit date and today as a Time.Duration object.
   */
  (:glance)
  function durationSince(quitDate as Time.Moment, today as Time.Moment) as Time.Duration {
    return today.subtract(quitDate);
  }

  /**
   * Calculates the elapsed time since the quit date until today.
   *
   * @param quitDate The quit date as a Time.Moment object.
   * @param today The current date as a Time.Moment object.
   * @return The elapsed time since the quit date as an ElapsedTime object.
   */
  (:glance)
  function elapsedTimeSince(quitDate as Time.Moment, today as Time.Moment) as ElapsedTime {
    var duration = durationSince(quitDate, today);
    var builder = new ElapsedTimeBuilder(duration);
    return builder.build();
  }

  /**
   * Calculates the number of cigarettes not smoked since the quit date.
   *
   * @param quitDate The date when the user quit smoking.
   * @param today The current date.
   * @param cigarettesPerDay The average number of cigarettes smoked per day.
   * @return The estimated number of cigarettes not smoked.
   */
  function cigarettesNotSmoked(quitDate as Time.Moment, today as Time.Moment, cigarettesPerDay as Number) as Number {
    var durationInSeconds = durationSince(quitDate, today).value();
    var days = Math.floor(durationInSeconds.toDouble() / dDay.toDouble()).toNumber();
    return days * cigarettesPerDay;
  }

  /**
   * Calculates the number of packs not bought since the quit date.
   *
   * @param quitDate The date when the user quit smoking.
   * @param today The current date.
   * @param cigarettesPerDay The average number of cigarettes smoked per day.
   * @param cigarettesPerPack The number of cigarettes in a pack.
   * @return The number of packs not bought.
   */
  function packsNotBought(quitDate as Time.Moment, today as Time.Moment, cigarettesPerDay as Number, cigarettesPerPack as Number) as Number {
    var cigarettes = cigarettesNotSmoked(quitDate, today, cigarettesPerDay);
    return ceil(cigarettes.toDouble() / cigarettesPerPack.toDouble());
  }
}

/**
 * Rounds up a decimal value to the nearest whole number.
 *
 * @param value The decimal value to round up.
 * @return The rounded up whole number.
 */
function ceil(value as Double) as Number {
  var intValue = value.toNumber();
  if (value == intValue) {
    return intValue;
  }
  return intValue + 1;
}
