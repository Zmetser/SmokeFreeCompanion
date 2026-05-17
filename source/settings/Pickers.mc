import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

import Settings;
import SettingsValueFormatter;

// ---- Factories ----

class WholeNumberFactory extends WatchUi.PickerFactory {
  private var _min as Number;
  private var _max as Number;
  private var _format as String;

  function initialize(min as Number, max as Number, format as String) {
    PickerFactory.initialize();
    _min = min;
    _max = max;
    _format = format;
  }

  function getSize() as Number {
    return _max - _min + 1;
  }

  function getValue(index as Number) as Object? {
    return index + _min;
  }

  function getIndex(value as Number) as Number {
    var idx = value - _min;
    if (idx < 0) { return 0; }
    if (idx >= getSize()) { return getSize() - 1; }
    return idx;
  }

  function getDrawable(index as Number, selected as Boolean) as WatchUi.Drawable? {
    var value = (index + _min) as Number;
    return new WatchUi.Text({
      :text => value.format(_format),
      :color => selected ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY,
      :font => Graphics.FONT_NUMBER_MILD,
      :locX => WatchUi.LAYOUT_HALIGN_CENTER,
      :locY => WatchUi.LAYOUT_VALIGN_CENTER,
    });
  }
}

// ---- Picker views ----

class WholeNumberPicker extends WatchUi.Picker {
  function initialize(title as String, min as Number, max as Number, defaultValue as Number) {
    var factory = new WholeNumberFactory(min, max, "%u");
    Picker.initialize({
      :title => _titleDrawable(title),
      :pattern => [factory],
      :defaults => [factory.getIndex(defaultValue)],
    });
  }
}

class PricePicker extends WatchUi.Picker {
  function initialize(title as String, defaultValue as Float) {
    var intFactory = new WholeNumberFactory(1, 9999, "%u");
    var decFactory = new WholeNumberFactory(0, 99, "%02d");
    var parts = SettingsValueFormatter.splitPrice(defaultValue);
    Picker.initialize({
      :title => _titleDrawable(title),
      :pattern => [
        intFactory,
        new WatchUi.Text({
          :text => ".",
          :color => Graphics.COLOR_WHITE,
          :font => Graphics.FONT_NUMBER_MILD,
          :locX => WatchUi.LAYOUT_HALIGN_CENTER,
          :locY => WatchUi.LAYOUT_VALIGN_CENTER,
        }),
        decFactory,
      ],
      :defaults => [intFactory.getIndex(parts[0]), 0, decFactory.getIndex(parts[1])],
    });
  }
}

class DatePicker extends WatchUi.Picker {
  function initialize(title as String, defaultMoment as Time.Moment) {
    var info = Gregorian.info(defaultMoment, Time.FORMAT_SHORT);
    var nowInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var maxYear = nowInfo.year as Number;
    var minYear = maxYear - 50;
    var yearFactory = new WholeNumberFactory(minYear, maxYear, "%u");
    var monthFactory = new WholeNumberFactory(1, 12, "%02d");
    var dayFactory = new WholeNumberFactory(1, 31, "%02d");
    Picker.initialize({
      :title => _titleDrawable(title),
      :pattern => [yearFactory, monthFactory, dayFactory],
      :defaults => [
        yearFactory.getIndex(info.year as Number),
        monthFactory.getIndex(info.month as Number),
        dayFactory.getIndex(info.day as Number),
      ],
    });
  }
}

function _titleDrawable(text as String) as WatchUi.Text {
  return new WatchUi.Text({
    :text => text,
    :color => Graphics.COLOR_WHITE,
    :font => Graphics.FONT_TINY,
    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
    :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
  });
}

// ---- Delegates (one per setting; avoids indirect-method-dispatch crash) ----

class CigarettesPerDayPickerDelegate extends WatchUi.PickerDelegate {
  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(values as Array) as Boolean {
    Settings.setCigarettesPerDay(values[0] as Number);
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }

  function onCancel() as Boolean {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }
}

class PackSizePickerDelegate extends WatchUi.PickerDelegate {
  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(values as Array) as Boolean {
    Settings.setPackSize(values[0] as Number);
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }

  function onCancel() as Boolean {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }
}

class PackPricePickerDelegate extends WatchUi.PickerDelegate {
  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(values as Array) as Boolean {
    var intPart = values[0] as Number;
    var decPart = values[2] as Number;
    Settings.setPackPrice(SettingsValueFormatter.combinePrice(intPart, decPart));
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }

  function onCancel() as Boolean {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }
}

class QuitDatePickerDelegate extends WatchUi.PickerDelegate {
  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(values as Array) as Boolean {
    var moment = Gregorian.moment({
      :year => values[0] as Number,
      :month => values[1] as Number,
      :day => values[2] as Number,
      :hour => 0,
      :minute => 0,
      :second => 0,
    });
    Settings.setQuitDate(moment);
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }

  function onCancel() as Boolean {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
    return true;
  }
}
