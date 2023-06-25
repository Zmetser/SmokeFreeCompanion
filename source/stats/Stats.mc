import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Math;

(:glance)
module Stats {

  var dHour = Gregorian.SECONDS_PER_HOUR;
  var dDay = Gregorian.SECONDS_PER_DAY;
  var dWeek = 7 * Gregorian.SECONDS_PER_DAY;

  // Calculate elapsed time since quitDate
  function elapsedSince(quitDate as Time.Moment) as Time.Duration {
    var today = new Time.Moment(Time.now().value());
    var elapsed = today.subtract(quitDate);
    return elapsed;
  }

  // TODO: Rest of the intervals
  // TODO: Minute precision
  function formatDuration(duration as Time.Duration, shorthand as Boolean) as String {
    // Less than 1 hour
    if (duration.lessThan(new Time.Duration(dHour))) {
      return "< 1 hour";
    }
    // Less than 1 day (1h 5m)
    else if (duration.lessThan(new Time.Duration(dDay))) {
      return formatHours(duration, shorthand);
    }
    // Less than 1 week (1d 2h 3m)
    else if (duration.lessThan(new Time.Duration(dWeek))) {
      return formatDays(duration, shorthand);
    }

    return "some time";
  }

  function formatHours(duration as Time.Duration, shorthand as Boolean) as String {
    var hours = Math.floor(24 * (duration.value().toFloat() / dDay));
    if (shorthand == true) {
      return Lang.format("$1$h", [hours.format("%d")]);
    } else {
      return Lang.format("$1$ hours", [hours.format("%d")]);
    }
  }

  function formatDays(duration as Time.Duration, shorthand as Boolean) as String {
    var days = Math.floor(7 * (duration.value().toFloat() / dWeek));
    var hours = Math.floor(24 * ((duration.value().toFloat() / dDay) - days));

    if (shorthand == true) {
      return Lang.format("$1$d $2$h", [
        days.format("%d"),
        hours.format("%d")
        ]);
    } else {
      return Lang.format("$1$ days $2$ hours", [
        days.format("%d"),
        hours.format("%d")
        ]);
    }
  }

}
