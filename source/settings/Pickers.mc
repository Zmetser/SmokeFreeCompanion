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
  private var _font as Graphics.FontType;

  function initialize(min as Number, max as Number, format as String, font as Graphics.FontType) {
    PickerFactory.initialize();
    _min = min;
    _max = max;
    _format = format;
    _font = font;
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
      :font => _font,
      :locX => WatchUi.LAYOUT_HALIGN_CENTER,
      :locY => WatchUi.LAYOUT_VALIGN_CENTER,
    });
  }
}

// ---- Picker views ----

class WholeNumberPicker extends WatchUi.Picker {
  function initialize(title as String, min as Number, max as Number, defaultValue as Number) {
    var factory = new WholeNumberFactory(min, max, "%u", Graphics.FONT_NUMBER_MILD);
    Picker.initialize({
      :title => _titleDrawable(title),
      :pattern => [factory],
      :defaults => [factory.getIndex(defaultValue)],
    });
  }
}

// Digit-per-column price picker. Layout per currency :pickerMode:
//   :narrow   — [tens, ones, ".", tenths]                  Float 0.0..99.9     (USD, EUR)
//   :hundreds — [thousands-digit, hundreds-digit, "00.0"]  Float 0..9900 / 100 (HUF)
class PricePicker extends WatchUi.Picker {
  function initialize(title as String, defaultValue as Float, pickerMode as Symbol) {
    var font = Graphics.FONT_NUMBER_MILD;

    if (pickerMode == :hundreds) {
      var v = defaultValue.toNumber();
      if (v < 0) { v = 0; }
      if (v > 9900) { v = 9900; }
      var thousands = (v / 1000) % 10;
      var hundreds = (v / 100) % 10;
      Picker.initialize({
        :title => _titleDrawable(title),
        :pattern => [
          new WholeNumberFactory(0, 9, "%u", font),
          new WholeNumberFactory(0, 9, "%u", font),
          _textDrawable("00.0", font),
        ],
        :defaults => [thousands, hundreds, 0],
      });
    } else {
      // :narrow (USD, EUR, and any future narrow-prefixed currency)
      var parts = SettingsValueFormatter.splitPriceWithTenths(defaultValue);
      Picker.initialize({
        :title => _titleDrawable(title),
        :pattern => [
          new WholeNumberFactory(0, 9, "%u", font),
          new WholeNumberFactory(0, 9, "%u", font),
          _textDrawable(".", font),
          new WholeNumberFactory(0, 9, "%u", font),
        ],
        :defaults => [parts[1], parts[2], 0, parts[3]],
      });
    }
  }
}

function _textDrawable(text as String, font as Graphics.FontType) as WatchUi.Text {
  return new WatchUi.Text({
    :text => text,
    :color => Graphics.COLOR_WHITE,
    :font => font,
    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
    :locY => WatchUi.LAYOUT_VALIGN_CENTER,
  });
}

class DatePicker extends WatchUi.Picker {
  function initialize(title as String, defaultMoment as Time.Moment) {
    var info = Gregorian.info(defaultMoment, Time.FORMAT_SHORT);
    var nowInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var maxYear = nowInfo.year as Number;
    var minYear = maxYear - 50;
    // FONT_MEDIUM (text) instead of FONT_NUMBER_MILD: three columns share the
    // screen, so a 4-digit year in the numeric font overflows its column.
    var dateFont = Graphics.FONT_MEDIUM;
    var yearFactory = new WholeNumberFactory(minYear, maxYear, "%u", dateFont);
    var monthFactory = new WholeNumberFactory(1, 12, "%02d", dateFont);
    var dayFactory = new WholeNumberFactory(1, 31, "%02d", dateFont);
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
  private var _pickerMode as Symbol;

  function initialize(pickerMode as Symbol) {
    PickerDelegate.initialize();
    _pickerMode = pickerMode;
  }

  function onAccept(values as Array) as Boolean {
    var price;
    if (_pickerMode == :hundreds) {
      // [thousands-digit, hundreds-digit, "00.0"]
      price = ((values[0] as Number) * 1000 + (values[1] as Number) * 100).toFloat();
    } else {
      // :narrow — [tens, ones, ".", tenths]
      var whole = (values[0] as Number) * 10 + (values[1] as Number);
      price = whole.toFloat() + (values[3] as Number).toFloat() / 10.0f;
    }
    Settings.setPackPrice(price);
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
