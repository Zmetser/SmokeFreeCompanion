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
    var elapsed = Stats.elapsedSince(yesterday);
    return (elapsed.value() == 86400);
  }

  // Durations
  (:test)
  function lessThanHour(logger as Logger) {
    var duration = Stats.formatDuration(
      new Time.Duration(Gregorian.SECONDS_PER_MINUTE * 10),
      false
      );

    logger.debug(duration);
    return "< 1 hour".equals(duration);
  }

  (:test)
  function lessThanDay(logger as Logger) {
    var duration = Stats.formatDuration(
      new Time.Duration(10 * Gregorian.SECONDS_PER_HOUR),
      false
      );

    logger.debug(duration);
    return "10 hours".equals(duration);
  }

  (:test)
  function lessThanWeek(logger as Logger) {
    var duration = Stats.formatDuration(
      new Time.Duration(Math.floor(5.5 * Gregorian.SECONDS_PER_DAY)),
      false
      );

    logger.debug(duration);
    return "5 days 12 hours".equals(duration);
  }

}
