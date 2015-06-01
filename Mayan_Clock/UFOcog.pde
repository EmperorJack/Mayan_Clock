/**
 * Class to hold variables and methods for a UFO cog. Rotates when
 * the minute or hour has changed and lights up using a glow piece.
 */
class UFOcog {

  // fields
  GlowPiece piece;
  float spinVelocity;
  float spinPercent;
  boolean spinning;
  float turnThrough;

  /**
   * Setup the new cog.
   */
  UFOcog (PShape shape, float pingVel) {
    piece = new GlowPiece(0, pingVel, shape);
    spinVelocity = 0.01;
    spinPercent = 0;
    spinning = false;
    turnThrough = 0;
  }

  /**
   * Start the UFO cog spining.
   */
  void spin(float tt) {
    // begin the spinning process
    spinning = true;
    piece.ping();

    // turn through the given angle
    turnThrough = tt;
    
    // start the hum sound
    humSound.unmute();
  }

  /**
   * Update the UFO cog current animation.
   */
  void update() {
    piece.update();

    if (spinning) {
      spinPercent += spinVelocity;
      piece.ping();

      // check if the spinning is complete
      if (spinPercent >= 1) {
        spinPercent = 0;
        spinning = false;
        
        // stop the hum sound
        humSound.mute();
      }
    }
  }

  /**
   * Draw the UFO cog in it's current position.
   */
  void render() {
    pushMatrix();
    rotate(map(spinPercent, 0, 1, 0, turnThrough));
    piece.render();
    popMatrix();
  }
}

