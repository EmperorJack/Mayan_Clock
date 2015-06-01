/**
 * Class to hold variables and methods for an alarm ring.
 * Allows the user to set the hour or minute the alarm gets triggered.
 */
class AlarmRing {

  // fields
  PShape SVG;
  int value;
  int maxValue;
  float angle;

  /**
   * Setup the new alarm setter ring.
   */
  AlarmRing(String type) {
    angle = -PI/2;
    value = 0;

    // is minute setter ring
    if (type == "Minute") {
      SVG = clock.getChild("alarmMinuteRing");
      maxValue = 60;
    }

    // is hour setter ring
    else if (type == "Hour") {
      SVG = clock.getChild("alarmHourRing");
      maxValue = 12;
    }
  }

  /**
   * Set the alarm setter to a new angle.
   */
  void setAngle(float ang) {
    angle = ang;
  }

  /**
   * Snap the alarm ring rotation to the closest hour / minute value;
   */
  void snapValue() {
    // find the exact value based on the current angle
    float valueAccurate = map(angle, -PI, PI, 0, maxValue);
    valueAccurate -= (maxValue/4);
    if (valueAccurate <= 0) {
      valueAccurate += maxValue;
    }

    // round to the closest hour / minute value
    value = round(valueAccurate) % maxValue;

    // snap the angle to the value position
    angle = map(value, 0, maxValue, 0, TWO_PI) -PI/2;

    // play ending move sound
    moveSound.play();
    moveSound.rewind();
  }

  /**
   * Draw the alarm ring in it's current position.
   */
  void render() {
    pushMatrix();
    //rotate(map(value, 0, maxValue, 0, TWO_PI) + angle);
    rotate(angle+PI/2);
    shape(SVG);
    popMatrix();
  }
}

