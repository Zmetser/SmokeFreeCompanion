import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

(:glance)
module Stats {
  typedef ElapsedTime as {
    :years as Number,
    :months as Number,
    :days as Number,
    :hours as Number,
    :minutes as Number
  };

  class ElapsedTimeBuilder {
    var duration as Time.Duration;

    private var _elapsedTime = {
      :years => 0,
      :months => 0,
      :days => 0,
      :hours => 0,
      :minutes => 0
    };

    function initialize(aDuration as Time.Duration) {
      duration = aDuration;
    }

    function build() as ElapsedTime {
      // Less than 1 hour
      if (duration.lessThan(new Time.Duration(dHour))) {
        return _calculateMinutes(duration);
      }
      // Less than 1 day (1h 5m)
      else if (duration.lessThan(new Time.Duration(dDay))) {
        return _calculateHours(duration);
      }
      // Less than 1 month (1d 2h 3m)
      else if (duration.lessThan(new Time.Duration(dMonth))) {
        return _calculateDays(duration);
      }
      // Less than a year (1m 2d 3h 4m)
      else if (duration.lessThan(new Time.Duration(12 * dMonth))) {
        return _calculateMonths(duration);
      }

      return _calculateYears(duration);
    }

    private function _calculateMinutes(duration as Time.Duration) as ElapsedTime {
      var minutes = Math.floor(duration.value() / 60);
      _elapsedTime.put(:minutes, minutes.toNumber());
      return _elapsedTime;
    }

    private function _calculateHours(duration as Time.Duration) as ElapsedTime {
      var hours = Math.floor(duration.value() / dHour);
      var remaining = duration.subtract(Gregorian.duration({ :hours => hours }));
      _elapsedTime.put(:hours, hours.toNumber());
      return _calculateMinutes(remaining);
    }

    private function _calculateDays(duration as Time.Duration) as ElapsedTime {
      var days = Math.floor(duration.value() / dDay);
      var remaining = duration.subtract(Gregorian.duration({ :days => days }));
      _elapsedTime.put(:days, days.toNumber());
      return _calculateHours(remaining);
    }

    private function _calculateMonths(duration as Time.Duration) as ElapsedTime {
      var months = Math.floor(duration.value() / dMonth);
      var remaining = duration.subtract(Gregorian.duration({ :days => months * DAYS_IN_MONTH }));
      _elapsedTime.put(:months, months.toNumber());
      return _calculateDays(remaining);
    }

    private function _calculateYears(duration as Time.Duration) as ElapsedTime {
      var years = Math.floor(duration.value() / (12 * dMonth));
      var remaining = duration.subtract(Gregorian.duration({ :days => years * 12 * DAYS_IN_MONTH }));
      _elapsedTime.put(:years, years.toNumber());
      return _calculateMonths(remaining);
    }
  }
}
