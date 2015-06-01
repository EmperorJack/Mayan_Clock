/**
 * Class to hold variables and methods for a cog.
 * Rotates to the current minute or hour for the current time.
 */
class Cog {

  // fields
  PShape SVG;
  int value;
  int lastValue;
  int maxValue;
  float transitionVelocity;
  float transitionPercent;
  boolean transitioning;

  /**
   * Setup the new cog.
   */
  Cog(String type, int val) {
    value = val;
    transitionVelocity = 0.01;
    transitionPercent = 0;
    transitioning = false;

    // is minute cog
    if (type == "Minute") {
      SVG = clock.getChild("minuteCog");
      maxValue = 60;
    }

    // is hour cog
    else if (type == "Hour") {
      SVG = clock.getChild("hourCog");
      maxValue = 12;
    }
  }

  /**
   * Update the cog with a given time value.
   * Start the transition process and animation.
   */
  void setValue(int val) {
    // begin the transition process
    transitioning = true;
    lastValue = value;
    value = val;
  }

  /**
   * Update the cog current animation.
   */
  void update() {
    if (transitioning) {
      transitionPercent += transitionVelocity;

      // check if the transition is complete
      if (transitionPercent >= 1) {
        transitionPercent = 0;
        transitioning = false;
        lastValue = value;

        // play ending move sound
        moveSound.play();
        moveSound.rewind();
      }
    }
  }

  /**
   * Draw the cog in it's current position.
   */
  void render() {
    pushMatrix();
    rotate(map(lastValue + transitionPercent, 0, maxValue, 0, TWO_PI));
    shape(SVG);
    popMatrix();
  }
}

