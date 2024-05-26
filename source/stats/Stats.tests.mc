import Toybox.Test;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;

import Stats;

(:test)
module TestConsts {
  import TestUtils;

  var today = Gregorian.moment({
    :year   => 2016,
    :month  => 3,
    :day    => 27,
    :hour   => 12,
    :minute => 0
  });

  var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);

  var quitDate = today.subtract(oneDay);
}

(:test)
module ElapsedTimeTests {
  import TestUtils;

  (:test)
  function canGetElapsedTime(logger as Logger) {
    var yesterday = TestConsts.today.subtract(TestConsts.oneDay);
    var elapsed = Stats.durationSince(yesterday, TestConsts.today);
    return (elapsed.value() == 86400);
  }

  // MARK: - Durations
  (:test)
  function lessThanHour(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(10 * Gregorian.SECONDS_PER_MINUTE))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 0, :hours => 0, :minutes => 10 });
  }

  (:test)
  function lessThanDay(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(10 * Gregorian.SECONDS_PER_HOUR))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 0, :hours => 10, :minutes => 0 });
  }

  (:test)
  function lessThanWeek(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(5.5 * Gregorian.SECONDS_PER_DAY))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 5, :hours => 11, :minutes => 58 });
  }

  (:test)
  function lessThanMonth(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(12.5 * Gregorian.SECONDS_PER_DAY))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 12, :hours => 12, :minutes => 1 });
  }

  (:test)
  function almostAMonth(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(29.9 * Gregorian.SECONDS_PER_DAY))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 0, :days => 29, :hours => 21, :minutes => 34 });
  }

  (:test)
  function lessThanYear(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(95 * Gregorian.SECONDS_PER_DAY))
      ),
      TestConsts.today
    );

    return TestUtils.verifyDictEquals(logger, duration, { :years => 0, :months => 3, :days => 5, :hours => 0, :minutes => 0 });
  }

  (:test)
  function twoYears(logger as Logger) {
    var duration = Stats.elapsedTimeSince(
      TestConsts.today.subtract(
        new Time.Duration(Math.floor(2 * Gregorian.SECONDS_PER_YEAR))
      ),
      TestConsts.today
    );
    return TestUtils.verifyDictEquals(logger, duration, { :years => 2, :months => 0, :days => 10, :hours => 12, :minutes => 0 });
  }
}

(:test)
module CigarettesNotSmokedTests {
  
  (:test)
  function cigsInHalfDay(logger as Logger) {
    var halfDay = new Time.Duration(Gregorian.SECONDS_PER_DAY / 2);
    var res = Stats.cigarettesNotSmoked(TestConsts.today.subtract(halfDay), TestConsts.today, 10);
    logger.debug(res);
    return TestUtils.verifyValueEquals(logger, res, 5);
  }

  (:test)
  function cigarettesNotSmoked(logger as Logger) {
    var res = Stats.cigarettesNotSmoked(TestConsts.quitDate, TestConsts.today, 10);
    return TestUtils.verifyValueEquals(logger, res, 10);
  }

  (:test)
  function cigsInTwoDays(logger as Logger) {
    var res = Stats.cigarettesNotSmoked(TestConsts.quitDate.subtract(TestConsts.oneDay), TestConsts.today, 10);
    return TestUtils.verifyValueEquals(logger, res, 20);
  }

  (:test)
  function cigsInOneYear(logger as Logger) {
    var res = Stats.cigarettesNotSmoked(TestConsts.quitDate.subtract(new Time.Duration(Gregorian.SECONDS_PER_YEAR)), TestConsts.today, 10);
    return TestUtils.verifyValueEquals(logger, res, 3662);
  }

  (:test)
  function packNotBought(logger as Logger) {
    var res = Stats.packsNotBought(TestConsts.quitDate, TestConsts.today, 10, 19);
    return TestUtils.verifyValueEquals(logger, res, 1);
  }

  (:test)
  function packsInTwoDays(logger as Logger) {
    var res = Stats.packsNotBought(TestConsts.quitDate.subtract(TestConsts.oneDay), TestConsts.today, 11, 19);
    return TestUtils.verifyValueEquals(logger, res, 2);
  }
}
