import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;

import Milestones;
import Settings;
import Stats;

class MilestonesView extends StatView {
  private var _units as Lang.Dictionary?;
  private var _arc as CircularProgressBar?;
  private var _descriptions as Array<String>?;
  private var _motivationals as Array< Array<String> >?;
  private var _currentMessage as String?;
  private var _descArea as WatchUi.TextArea?;

  private const STORAGE_KEY_BANDS_SEEN = "milestonesBandsSeen";

  // Entry animation: arc sweeps 0 → real progress on view show.
  // Driven by System.getTimer() inside onUpdate (no Timer.Timer — instance
  // method indirect lookup crashes the TVM, see learning_monkeyc_indirect_method_lookup).
  private const ANIM_DURATION_MS = 700;
  private var _animStartMs as Number = 0;

  function initialize() {
    StatView.initialize();
  }

  function onLayout(dc as Dc) as Void {
    StatView.onLayout(dc);

    _units = {
      :minute => Application.loadResource(Rez.Strings.Milestones_UnitMinute) as String,
      :hour => Application.loadResource(Rez.Strings.Milestones_UnitHour) as String,
      :day => Application.loadResource(Rez.Strings.Milestones_UnitDay) as String,
      :week => Application.loadResource(Rez.Strings.Milestones_UnitWeek) as String,
      :month => Application.loadResource(Rez.Strings.Milestones_UnitMonth) as String,
      :year => Application.loadResource(Rez.Strings.Milestones_UnitYear) as String,
    };

    _arc = new CircularProgressBar({
      :colorBase => Graphics.COLOR_DK_GRAY,
      :colorActive => Graphics.COLOR_BLUE,
    });

    _descriptions = [
      Application.loadResource(Rez.Strings.Milestones_Desc_20min) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_8h) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_24h) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_48h) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_72h) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_Weeks) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_Months) as String,
      Application.loadResource(Rez.Strings.Milestones_Desc_1y) as String,
    ];

    _motivationals = [
      [Application.loadResource(Rez.Strings.Milestones_Mot_20min_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_20min_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_8h_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_8h_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_24h_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_24h_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_48h_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_48h_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_72h_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_72h_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_Weeks_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_Weeks_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_Months_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_Months_2) as String],
      [Application.loadResource(Rez.Strings.Milestones_Mot_1y_1) as String,
       Application.loadResource(Rez.Strings.Milestones_Mot_1y_2) as String],
    ];

    var width = dc.getWidth();
    var height = dc.getHeight();
    _descArea = new WatchUi.TextArea({
      :text => "",
      :color => Graphics.COLOR_LT_GRAY,
      :font => [Graphics.FONT_TINY, Graphics.FONT_XTINY],
      :locX => (width * 0.15).toNumber(),
      :locY => (height * 0.55).toNumber(),
      :width => (width * 0.7).toNumber(),
      :height => (height * 0.35).toNumber(),
      :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
    });
  }

  function onShow() as Void {
    StatView.onShow();
    _animStartMs = System.getTimer();

    var now = new Time.Moment(Time.now().value());
    var nextSeconds = Milestones.closestMilestoneTo(Settings.getQuitDate(), now);
    _currentMessage = pickMessageFor(Milestones.bandIndexFor(nextSeconds));
  }

  // First visit to a band: show the NHS fact and mark the band seen.
  // Subsequent visits: random pick across {NHS, motivationals[band]...}.
  // Persistence is a 6-bit bitfield in Application.Storage so we keep one key
  // instead of six; unset reads as 0 so v0.5.0 upgraders behave like fresh installs.
  private function pickMessageFor(band as Number) as String {
    var raw = Application.Storage.getValue(STORAGE_KEY_BANDS_SEEN);
    var seen = (raw instanceof Lang.Number) ? raw : 0;
    var mask = 1 << band;

    if ((seen & mask) == 0) {
      Application.Storage.setValue(STORAGE_KEY_BANDS_SEEN, seen | mask);
      return _descriptions[band];
    }

    var motivationals = _motivationals[band];
    var poolSize = 1 + motivationals.size();
    var pick = Math.rand() % poolSize;
    if (pick == 0) { return _descriptions[band]; }
    return motivationals[pick - 1];
  }

  function onUpdate(dc as Dc) as Void {
    var now = new Time.Moment(Time.now().value());
    var quitDate = Settings.getQuitDate();

    var nextSeconds = Milestones.closestMilestoneTo(quitDate, now);
    var progress = Milestones.milestoneProgress(quitDate, now);

    // "elapsed<finerUnit> / target<targetUnit>" — e.g. "23h / 48h", "5d / 1w", "260d / 1y".
    var elapsedSeconds = Stats.durationSince(quitDate, now).value();
    var elapsedDivisor = Milestones.elapsedDivisorFor(nextSeconds);
    var elapsedCount = elapsedSeconds / elapsedDivisor;
    var elapsedUnit = Milestones.elapsedUnitFor(nextSeconds, _units);
    var targetLabel = Milestones.labelFor(nextSeconds, _units);
    title = elapsedCount.toString() + elapsedUnit + " / " + targetLabel;

    _descArea.setText(_currentMessage);

    StatView.onUpdate(dc);
    _descArea.draw(dc);

    var t = (System.getTimer() - _animStartMs).toFloat() / ANIM_DURATION_MS.toFloat();
    var animating = t < 1.0;
    if (t > 1.0) { t = 1.0; }
    if (t < 0.0) { t = 0.0; } // System.getTimer() rollover guard
    // Ease-out quadratic: 1 - (1-t)^2
    var eased = 1.0 - (1.0 - t) * (1.0 - t);
    _arc.setValue(progress * eased);
    _arc.draw(dc);

    if (animating) {
      WatchUi.requestUpdate();
    }
  }

  // FONT_NUMBER_* variants are digits-only — the unit suffix ("d" / "mo" / "y")
  // would render as a tofu box. FONT_LARGE has the full glyph set.
  // Title sits in the upper third; description TextArea owns the lower half.
  function drawTitle(dc as Dc) as Void {
    var height = dc.getHeight();
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(titleX, (height * 0.32).toNumber(), Graphics.FONT_LARGE, title, Graphics.TEXT_JUSTIFY_CENTER);
  }

  // Subtitle is now replaced by the description TextArea — no-op.
  function drawSubTitle(dc as Dc) as Void {}
}
