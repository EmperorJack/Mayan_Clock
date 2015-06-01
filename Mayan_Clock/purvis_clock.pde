/*
 * MDDN 242 Project 1: Awkward Clocks
 * Jack Purvis (300311934)
 * Mystery Mayan Clock
 */

import ddf.minim.*;

// sketch fields
int centerX;
int centerY;
float clockScale;
PImage docImage;

// time fields
int hour;
int minute;
int second;
int lastSecond;
int lastMinute;
int lastHour;
int minuteTarget;
int hourTarget;
boolean alarmState;
boolean snoozeState;

// svg fields
PShape clock;
PShape centerPiece;
PShape clockBase;
PShape sectionRings;
PShape hourIndicator;
PShape glowList;
PShape face;

// cog fields
Cog minuteCog;
Cog hourCog;
UFOcog minuteUFOcog;
UFOcog hourUFOcog;

// ring fields
AlarmRing minuteRing;
AlarmRing hourRing;

// glow piece fields
GlowPiece[] glowPieces;
GlowPiece glowEyes;

// sound fields
Minim minim;
AudioPlayer moveSound;
AudioPlayer humSound;
AudioPlayer alarmSound;

/*
 * Perform the initial setup of the clock
 */
void initializeMyClock() {
  // sketch init
  centerX = width/2;
  centerY = height/2;
  clockScale = min(width/1500f, height/1500f);
  frameRate(60);
  docImage = loadImage("documentation.jpg");

  // svg init
  clock = loadShape("clock.svg");
  centerPiece = clock.getChild("centerPieces");
  clockBase = clock.getChild("bases");
  sectionRings = clock.getChild("rings");
  hourIndicator = clock.getChild("hourIndicator");
  glowList = clock.getChild("glowList");

  // non-global svgs
  PShape mUFOcog = clock.getChild("UFOcogMinute");
  PShape hUFOcog = clock.getChild("UFOcogHour");
  PShape eyes = clock.getChild("eyes");

  // object init
  // minute / hour cogs
  minuteCog = new Cog("Minute", minute);
  hourCog = new Cog("Hour", hour);

  // alarm setter rings
  minuteRing = new AlarmRing("Minute");
  hourRing = new AlarmRing("Hour");

  // UFO cogs
  minuteUFOcog = new UFOcog(mUFOcog, 0.075);
  hourUFOcog = new UFOcog(hUFOcog, 0.15);

  // glowing sections
  glowEyes = new GlowPiece(0, 0.01, eyes);
  glowPiecesInit();

  // sound init
  // the alarm and hum should be continuously playing
  // so that they can be muted and unmuted when needed
  minim = new Minim(this);
  moveSound = minim.loadFile("move.wav");
  humSound = minim.loadFile("hum.wav");
  humSound.loop();
  humSound.mute();
  alarmSound = minim.loadFile("alarm.wav");
  alarmSound.loop();
  alarmSound.mute();

  // mouse init
  mouseSetup();

  // time init
  second = second();
  minute = minute();
  hour = hour() % 12;
  lastSecond = second - 1;
  lastMinute = minute - 1;
  lastHour = hour - 1;
  minuteTarget = 0;
  hourTarget = 0;
  alarmState = false;
  snoozeState = false;

  minuteCog.setValue(lastMinute);
  hourCog.setValue(lastHour);
}

/*
 * Initialize the list of individual glow piece objects.
 */
void glowPiecesInit() {
  glowPieces = new GlowPiece[60];
  float glowVelocity = 0.0175;

  // for each glow piece needed
  for (int i = 0; i < 60; i+=5) {
    // add the next hour piece
    glowPieces[i] = new GlowPiece(map(i, 0, 60, 0, TWO_PI), glowVelocity, glowList.getChild(str(i/5)));

    // add the next four second/minute pieces
    glowPieces[i+1] = new GlowPiece(map(i+1, 0, 60, 0, TWO_PI), glowVelocity, glowList.getChild("shortBar"));
    glowPieces[i+2] = new GlowPiece(map(i+2, 0, 60, 0, TWO_PI), glowVelocity, glowList.getChild("longBar"));
    glowPieces[i+3] = new GlowPiece(map(i+3, 0, 60, 0, TWO_PI), glowVelocity, glowList.getChild("longBar"));
    glowPieces[i+4] = new GlowPiece(map(i+4, 0, 60, 0, TWO_PI), glowVelocity, glowList.getChild("shortBar"));
  }
}

/**
 * Update the time and call updates on clock objects.
 */
void runClock() {
  background(#000000);
  //println(frameRate);

  // get the current time
  second = second();
  minute = minute();
  hour = hour() % 12;

  // if the alarm target has been reached activate the alarm state
  // if the snooze state active just disable the alarm state instead
  // if documentation active do not go into alarm state
  if (minute == minuteTarget && hour == hourTarget && !snoozeState &&
    !displayDocumentation) {
    alarmState = true;
  } else {
    // or disable it if it's past the target time
    // thus the alarm lasts for a minute unless it's disabled
    // or the target time is changed
    alarmState = false;
    alarmSound.mute();
  }

  // update the alarm state if it is active
  if (alarmState) {
    updateAlarmState();
  }

  checkHourChanged();
  checkMinuteChanged();
  checkSecondChanged();

  // update the cogs
  minuteCog.update();
  hourCog.update();

  // update the UFO cogs
  minuteUFOcog.update();
  hourUFOcog.update();

  // update the glowing pieces
  for (GlowPiece gp : glowPieces) {
    gp.update();
  }
  // light up the face eyes
  glowEyes.update();

  // draw the clock
  drawMayanClock();
}

/**
 * Check if the hour has changed and update.
 */
void checkHourChanged() {
  if (hour != lastHour) {
    lastHour = hour;
    hourChanged();

    // hour changed so minute must have too
    checkMinuteChanged();
  }
}

/**
 * Check if the minute has changed and update.
 */
void checkMinuteChanged() {
  if (minute != lastMinute) {
    lastMinute = minute;
    minuteChanged();

    // minute changed so second must have too
    checkSecondChanged();
  }
}

/**
 * Check if the second has changed and update.
 */
void checkSecondChanged() {
  if (second != lastSecond) {
    lastSecond = second;
    secondChanged();
  }
}

/**
 * If the hour has changed apply the following.
 */
void hourChanged() {
  // light up and spin the hour UFO hour cog
  hourUFOcog.spin(-PI);

  // update the hour cog values
  hourCog.setValue(hour);

  // ping all the pieces
  pingAllPieces();
}

/**
 * If the minute has changed apply the following.
 */
void minuteChanged() {
  // light up and spin the minute UFO minute cog
  minuteUFOcog.spin(-PI/6);

  // update the minute cog values
  minuteCog.setValue(minute);

  // play starting move sound
  moveSound.play();
  moveSound.rewind();

  // light up the face eyes
  glowEyes.ping();

  // snooze state is disabled after a minute so the
  // alarm can be activated again on a new setting
  snoozeState = false;
}

/**
 * If the second has changed apply the following.
 */
void secondChanged() {
  // print out the new time
  //println(hour + " : " + minute + " : " + second);

  // ping the current piece
  glowPieces[second].ping();
}

/**
 * Update the alarm state
 */
void updateAlarmState() {
  // activate all the animations
  hourUFOcog.spin(-PI);
  minuteUFOcog.spin(-PI/6);

  // pulse all the pieces
  pingAllPieces();

  // light up the face eyes
  glowEyes.ping();

  // start the hum sound
  humSound.unmute();

  // start the alarm sound
  alarmSound.unmute();
}

/**
 * Ping all the outer pieces
 */
void pingAllPieces() {
  for (GlowPiece gp : glowPieces) {
    gp.ping();
  }
}

/**
 * Draw the clock objects in their current state.
 */
void drawMayanClock() {
  pushMatrix();

  // move to the center of the canvas and scale the
  // clock to fit the sketch size
  translate(centerX, centerY);
  scale(clockScale, clockScale);

  shape(clockBase);
  shape(sectionRings);
  shape(centerPiece);

  // draw the glowing ufo cogs
  minuteUFOcog.render();
  hourUFOcog.render();

  // draw the alarm setter rings
  minuteRing.render();
  hourRing.render();

  // draw the time cogs
  minuteCog.render();

  hourCog.render();

  // draw the glowing second/minute pieces
  for (int i = 0; i < 60; i++) {
    if (!(i % 5 == 0)) {
      glowPieces[i].render();
    }
  }

  // draw the other glowing pieces
  glowEyes.render();
  drawHourIndicators();

  popMatrix();
}

/**
 * Draw the glowing hour symbols and base shapes below them.
 */
void drawHourIndicators() {
  for (int i = 0; i < 12; i++) {
    pushMatrix();
    rotate(map(i, 0, 12, 0, TWO_PI));
    shape(hourIndicator);
    popMatrix();

    // draw the corresponding glow piece which
    // is also the symbol for the hour
    glowPieces[i*5].render();
  }
}

/**
 * Draw the documentation overlay.
 */
void showDocumentation() {
  if (displayDocumentation) {
    image(docImage, 0, 0, width, height);
  }
}

/**
 * Unused method.
 */
void runKeyPressed() {
  //Put any custom keyPressed Logic here
}

