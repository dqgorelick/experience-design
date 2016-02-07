// make sure to install controlP5 for the GUI!
import controlP5.*;
import processing.pdf.*;
ControlP5 cp5;

float speed_limit = 0.4;

boolean paused = false;
boolean reset = false;
boolean mouse_control = true;
boolean stroke_change = true;
boolean circles = true;
boolean moved = false;
boolean hide_controls = false;
boolean screenshot = false;

int offset;
int control_width = 170/2;
int opacity = 100;
float line_width = 10;

//color [] colors = { 
//  color(255, 0, 0, opacity), // red 
//  color(255, 0, 255, opacity), // magenta
//  color(0, 255, 255, opacity), // cyan
//  color(0, 0, 255, opacity), // blue
//};

float radius_one = 300;
float radius_two = 500;
float radian_one = 0;
float radian_two = 0;
float speed_one = 0.10;
float speed_two = 0.05;

int decay_rate = 8;

String[] sliders = new String[] {"radius_one", "radius_two", "speed_one", "speed_two", "decay_rate", "line_width", "label"};

void setupSliders() {
  for (int i = 0; i < sliders.length; i++) {
    if (hide_controls) {
      cp5.getController(sliders[i]).setPosition(-200, 20+45*i);
    } else {
      cp5.getController(sliders[i]).setPosition(20, 20+45*i);
    }
    cp5.getController(sliders[i]).setSize(150, 25);
    cp5.getController(sliders[i]).getCaptionLabel().align(cp5.LEFT, cp5.BOTTOM_OUTSIDE).setPaddingX(4);
    if (sliders[i] != "label") {
      cp5.getController(sliders[i]).getValueLabel().align(cp5.RIGHT, cp5.BOTTOM_OUTSIDE).setPaddingX(4);
    }
  }
}

void updateGUI() {
  cp5.getController("speed_one").setValue(speed_one);
  cp5.getController("speed_two").setValue(speed_two);
  cp5.getController("radius_one").setValue(radius_one);
  cp5.getController("radius_two").setValue(radius_two);
  if (stroke_change) { 
    cp5.getController("line_width").setValue(radius_two/15);
  }
}

void setup() {
  size(800, 600);
  //fullScreen();
  background(0);
  offset = width/2 + control_width;
  cp5 = new ControlP5(this);
  cp5.addSlider("speed_one")
    .setRange(-speed_limit, speed_limit)
    .setDecimalPrecision(3)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("speed_two")
    .setRange(-speed_limit, speed_limit)
    .setDecimalPrecision(3)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("radius_one")
    .setRange(0, width/1.414213562)
    .setDecimalPrecision(0)
    .setValue(floor(random(width*0.05, width*0.15)))
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("radius_two")
    .setRange(0, height/1.414213562)
    .setDecimalPrecision(0)
    .setValue(floor(random(height*0.25, height*0.33)))
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("decay_rate")
    .setValue(decay_rate)
    .setRange(0, 25)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("line_width")
    .setValue(line_width)
    .setRange(1, 30)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addTextlabel("label")
    .setText("\nKEYBINDS:\n\n[ h ] = hide controls\n[ r ] = reset\n[ m ] = mouse mode toggle\n[ c ] = circles toggle\n[ l ] = dynamic line width\n\n\n[ SPACEBAR ] = pause\n\n[ s ] = save screen as PDF");
  setupSliders();
}
//.setColorForeground(color(155))

void keyPressed() {
  switch(key) {
  case ' ':
    paused = (paused ? false : true);
    break;
  case 'r': 
    reset = true;
    break;
  case 'm':
    mouse_control = (mouse_control ? false : true);
    break;
  case 'c':
    circles = (circles ? false : true);
    break;
  case 'l':
    stroke_change = (stroke_change ? false : true);
    break;
  case 's':
    screenshot = true;
    break;
  case 'h': 
    if (hide_controls) {
      reset = true;
      offset = width/2 + control_width;
      hide_controls = false;
    } else {
      offset = width/2;
      reset = true;
      hide_controls = true;
    }
    setupSliders();
    break;
  }
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      speed_two = (speed_two <= speed_limit) ? speed_two += 0.025: speed_two;
      break;
    case DOWN:
      speed_two = (speed_two >= -speed_limit) ? speed_two -= 0.025: speed_two;
      break;
    case RIGHT:
      speed_one = (speed_one <= speed_limit) ? speed_one += 0.025: speed_one;
      break;
    case LEFT:
      speed_one = (speed_one >= -speed_limit) ? speed_one -= 0.025: speed_one;
      break;
    }
  }
}

void draw() {
  updateGUI();
  if (reset) {
    background(0);
    reset = false;
  }
  if (!paused) {
    if (mouse_control) {
      if (!moved && mouseX != 0 || mouseY != 0) {
        moved = true;
      }
      if (moved) {
        radius_one = mouseX/1.414213562;
        radius_two = mouseY/1.414213562;
      }
    }
    radian_one += speed_one;
    radian_two += speed_two;
    fill(0, decay_rate);
    strokeCap(SQUARE);
    noStroke();
    rect(0, 0, width, height);
    noFill();
    if (stroke_change) {
      strokeWeight(radius_two/15);
    } else {
      strokeWeight(line_width);
    }
    stroke(255, 0, 255, 100);
    line(offset + sin(radian_one)*radius_one, height/2 + cos(radian_one)*radius_one, offset + sin(radian_two)*radius_two, height/2 + cos(radian_two)*radius_two);
    stroke(0, 255, 255, 100);
    line(offset + sin(radian_one + PI)*radius_one, height/2 + cos(radian_one + PI)*radius_one, offset + sin(radian_two + PI)*radius_two, height/2 + cos(radian_two + PI)*radius_two);
    strokeWeight(0.5);
    if (circles) {  
      ellipse(offset, height/2, radius_two*2, radius_two*2);
      stroke(255, 0, 255, 100);
      ellipse(offset, height/2, radius_one*2, radius_one*2);
    }
    if (!hide_controls) {
      fill(0);
      noStroke();
      rect(0, 0, 190, height);
      rect(0, 0, width, 20);
      rect(width-20, 0, 20, height);
      rect(0, height-20, width, 20);
      rect(0, 0, 190, height);
      stroke(255, 255, 255);
      noFill();
      strokeWeight(1);
      rect(190, 20, width-210, height-40);
    }
    if (screenshot) {
      if (!hide_controls) {
        PImage img = get(190, 20, width-210, height-40);
        img.save("frame-" + frameCount + ".png");
      } else {
        PImage img = get(0, 0, width, height);
        img.save("frame-" + frameCount + ".png");
      }
      screenshot = false;
    }
  }
}  