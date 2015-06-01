/**
 * Tab to deal with mouse interface.
 */

// fields
float hourRingBound;
float middleRingBound;
float minuteRingBound;
float centerPieceBound;
boolean minuteRingDragged;
boolean hourRingDragged;

void mouseSetup() {
  hourRingBound = 700 * clockScale;
  middleRingBound = 650 * clockScale;
  minuteRingBound = 600 * clockScale;
  centerPieceBound = 200 * clockScale;
  minuteRingDragged = false;
  hourRingDragged = false;
}

/**
 * When a mouse button is pressed.
 */
void mousePressed() {
  if (mouseButton == LEFT) {
    if (withinCenterPiece()) {
      // clicking on the center piece will activate the snooze feature
      // which disables the clock
      snoozeState = true;
    } else if (withinMinuteRing()) {
      // allow rotation of the minute ring
      minuteRingDragged = true;
    } else if (withinHourRing()) {
      // allow rotation of the hour ring
      hourRingDragged = true;
    }
  }
}

/**
 * When a mouse button is dragged.
 */
void mouseDragged() {
  if (minuteRingDragged) {
    // update the minute ring to reflect the current angle dragged to
    minuteRing.setAngle(atan2(mouseY-centerY, mouseX-centerX));
  } else if (hourRingDragged) {
    // update the hour ring to reflect the current angle dragged to
    hourRing.setAngle(atan2(mouseY-centerY, mouseX-centerX));
  }
}

/**
 * When a mouse button is released.
 */
void mouseReleased() {
  if (mouseButton == LEFT) {
    if (minuteRingDragged) {
      // snap the minute ring value and get the new target minute
      minuteRingDragged = false;
      minuteRing.snapValue();
      minuteTarget = minuteRing.value;
    }
    if (hourRingDragged) {
      // snap the hour ring value and get the new target hour
      hourRingDragged = false;
      hourRing.snapValue();
      hourTarget = hourRing.value;
    }
  }
}

/**
 * Is the mouse currently within the alarm hour setter ring.
 */
boolean withinHourRing() {
  if (abs(hypot(mouseX-centerX, mouseY-centerY)) < hourRingBound
    && !(abs(hypot(mouseX-centerX, mouseY-centerY)) < middleRingBound)) {
    return true;
  }
  return false;
}

/**
 * Is the mouse currently within the alarm minute setter ring.
 */
boolean withinMinuteRing() {
  if (abs(hypot(mouseX-centerX, mouseY-centerY)) < middleRingBound
    && !(abs(hypot(mouseX-centerX, mouseY-centerY)) < minuteRingBound)) {
    return true;
  }
  return false;
}

/**
 * Is the mouse currently within the center piece.
 */
boolean withinCenterPiece() {
  if (abs(hypot(mouseX-centerX, mouseY-centerY)) < centerPieceBound) {
    return true;
  }
  return false;
}

/**
 * Returns the length of the hypotenuse from the given a and b.
 */
float hypot(float a, float b) {
  return sqrt((a*a) + (b*b));
}

