/**
 * Class to hold variables and methods for a glowing piece. Each piece
 * is either a symbol representing an hour increment or line representing
 * a second/minute increment. These sections are pinged so they glow.
 */
class GlowPiece {

  // fields
  PShape piece;
  float rotation;
  float pingVelocity;
  float pingPercent;
  boolean pinging;
  color baseColour = #4C3327;
  color pingColour = #88BEBE;

  /**
   * Setup the new glow piece.
   */
  GlowPiece(float rot, float vel, PShape svg) {
    rotation = rot;
    piece = svg;
    pingVelocity = vel;
    pingPercent = 0;
    pinging = false;
    svg.disableStyle();
  }

  /**
   * Start this glow piece pinging.
   */
  void ping() {
    // begin the pinging process
    pinging = true;
  }

  /**
   * Update the glow piece current animation.
   */
  void update() {
    if (pinging) {
      // this effectively increases the opacity of the glow
      pingPercent += pingVelocity;

      // check if the pinging is halfway complete and if so
      // start decreasing the opactity of the glow
      if (pingPercent >= 1) {
        pingVelocity *= -1;
        pingPercent += pingVelocity;
      }

      // check if the pinging is complete
      if (pingPercent <= 0) {
        pingPercent = 0;
        pinging = false;
        pingVelocity *= -1;
      }
    }
  }

  /**
   * Draw the glow piece in it's position.
   */
  void render() {
    pushMatrix();
    rotate(rotation);

    // draw a non-glowing piece either way
    noStroke();
    fill(baseColour);
    shape(piece);

    // if pinging draw the glowed section overlay
    if (pinging) {
      strokeWeight(5);
      stroke(pingColour, pingPercent * 50);
      fill(pingColour, pingPercent * 200);
      shape(piece);
    }

    shape(piece);
    popMatrix();
  }
}

