(:test)
module StatsTests {
  import Toybox.Test;
  import Toybox.Math;
  import Toybox.Time;
  import Toybox.Time.Gregorian;

  import Stats;
  import TestUtils;

  // MARK: - Setup
  var today = Gregorian.moment({
    :year   => 2016,
    :month  => 3,
    :day    => 27,
    :hour   => 12,
    :minute => 0
  });
  // var today = new Time.Moment();
  var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);

  (:test)
  function canGetElapsedTime(logger as Logger) {
    var yesterday = today.subtract(oneDay);
    var elapsed = Stats.durationSince(yesterday, today);
    return (elapsed.value() == 86400);
  }

  // MARK: - Durations
  (:test)
  function lessThanHour(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(10 * Gregorian.SECONDS_PER_MINUTE))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 0, :hours => 0, :minutes => 10 });
  }

  (:test)
  function lessThanDay(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(10 * Gregorian.SECONDS_PER_HOUR))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 0, :hours => 10, :minutes => 0 });
  }

  (:test)
  function lessThanWeek(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(5.5 * Gregorian.SECONDS_PER_DAY))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 5, :hours => 11, :minutes => 58 });
  }

  (:test)
  function lessThanMonth(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(12.5 * Gregorian.SECONDS_PER_DAY))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 12, :hours => 12, :minutes => 1 });
  }

  (:test)
  function almostAMonth(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(29.9 * Gregorian.SECONDS_PER_DAY))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 29, :hours => 21, :minutes => 34 });
  }

  (:test)
  function lessThanYear(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(95 * Gregorian.SECONDS_PER_DAY))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 3, :days => 5, :hours => 0, :minutes => 0 });
  }

  (:test)
  function twoYears(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      today.subtract(
        new Time.Duration(Math.floor(2 * 365 * Gregorian.SECONDS_PER_DAY))
      ),
      today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 2, :months => 0, :days => 10, :hours => 0, :minutes => 0 });
  }

}
