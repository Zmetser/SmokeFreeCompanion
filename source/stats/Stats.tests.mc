import Toybox.Test;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Stats;

module StatsTests {

  var today = new Time.Moment(Time.now().value());
  var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);

  (:test)
  function canGetElapsedTime(logger as Logger) {
    var yesterday = today.subtract(oneDay);
    var elapsed = Stats.durationSince(yesterday);
    return (elapsed.value() == 86400);
  }

  // Durations
  (:test)
  function lessThanHour(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(129.985 * Gregorian.SECONDS_PER_DAY))
      )
    );

    logger.debug(duration);
    return "10m".equals(duration);
  }

  // (:test)
  // function lessThanDay(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(10 * Gregorian.SECONDS_PER_HOUR));

  //   logger.log(duration)
  //   return "10h 0m".equals(duration);
  // }

  // (:test)
  // function lessThanWeek(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(Math.floor(5.5 * Gregorian.SECONDS_PER_DAY)));

  //   logger.log(duration)
  //   return "5d 12h 0m".equals(duration);
  // }

  // (:test)
  // function lessThanMonth(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(Math.floor(12.5 * Gregorian.SECONDS_PER_DAY)));

  //   logger.log(duration)
  //   return "12d 12h 0m".equals(duration);
  // }

  // (:test)
  // function almostAMonth(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(Math.floor(29.9 * Gregorian.SECONDS_PER_DAY)));

  //   logger.log(duration)
  //   return "29d 21h 36m".equals(duration);
  // }

  // (:test)
  // function lessThanYear(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(Math.floor(95 * Gregorian.SECONDS_PER_DAY)));

  //   logger.log(duration)
  //   return "3m 5d 0h 0m".equals(duration);
  // }

  // (:test)
  // function twoYears(logger as Logger) {
  //   var duration = Stats.formatDurationSince(
  //     new Time.Duration(Math.floor(2 * 365 * Gregorian.SECONDS_PER_DAY)));

  //   logger.log(duration)
  //   return "2y 10d 0h 0m".equals(duration);
  // }

}
