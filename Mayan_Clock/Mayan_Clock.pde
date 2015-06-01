//-----------------------
// DO NOT TOUCH THIS
//-----------------------

import java.util.Date;
import java.text.SimpleDateFormat;

int initialH, initialM, initialS;
boolean displayDocumentation = false;
boolean alarmMode = false;

void initialize() {
  //current hour
  initialH = hour();
  //current minute
  initialM = minute();
  //current second
  initialS = second();

  initializeMyClock();
}

void setup() {
  size(1024, 768);
  smooth();
  PFont f = createFont("SansSerif", 24);
  textFont(f);
  initialize();
  initializeMyClock();
}

void draw() {
  pushStyle();
  pushMatrix();
  runClock();
  popMatrix();
  popStyle();
  
  if (displayDocumentation) {  
    pushMatrix();  
    pushStyle();
    showDocumentation();
    popMatrix();
    popStyle();
  }
}


void keyPressed() {
  if (key == 's') {
    float id = random(1) + millis();
    String file = "screengrabs/capture_" + id + ".png"; 
    saveFrame(file);
  }
  if (key == 'h') {
    displayDocumentation = !displayDocumentation;
  }
  
  if( !displayDocumentation) { //Dont go into alarm mode if the documentation is being displayed
  if (key == 'a') {
    alarmMode = !alarmMode; 
  }
  }
  
  runKeyPressed();
}

