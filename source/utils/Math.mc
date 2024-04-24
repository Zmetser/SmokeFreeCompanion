import Toybox.Lang;

/**
* Calculates the absolute value of a number.
*
* @param a The number to calculate the absolute value of.
* @return The absolute value of the input number.
*/
function abs(a as Lang.Numeric) as Lang.Numeric {
  return a < 0 ? -a : a;
}
