import Toybox.Application;
import Toybox.Lang;

(:glance)
class PropertyReader {
  function initialize() {}

  function getValue(key as String) as Object? {
    return null;
  }
}

(:glance)
class ApplicationPropertyReader extends PropertyReader {
  function initialize() {
    PropertyReader.initialize();
  }

  function getValue(key as String) as Object? {
    return Properties.getValue(key);
  }
}

(:test)
class DictPropertyReader extends PropertyReader {
  private var _values as Dictionary;

  function initialize(values as Dictionary) {
    PropertyReader.initialize();
    _values = values;
  }

  function getValue(key as String) as Object? {
    if (_values.hasKey(key)) {
      return _values.get(key);
    }
    return null;
  }
}
