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

  // Calculate elapsed time since quitDate
  (:glance)
  function durationSince(quitDate as Time.Moment) as Time.Duration {
    var today = new Time.Moment(Time.now().value());
    var elapsed = today.subtract(quitDate);
    return elapsed;
  }

  function formatDurationSince(quitDate as Time.Moment) as String {
    return "";
  }

  (:glance)
  function elapsedTimeSince(quitDate as Time.Moment) as ElapsedTime {
    var duration = durationSince(quitDate);
    var builder = new ElapsedTimeBuilder(duration);
    return builder.build();
  }

}
