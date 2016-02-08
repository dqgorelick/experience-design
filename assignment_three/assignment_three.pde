import controlP5.*;
ControlP5 cp5;

boolean paused = false;
boolean mouse_control = true;
boolean stroke_change = true;
boolean circles = true;
boolean hide_controls = false;

float hue_one, hue_two, speed_one, speed_two, radius_one, radius_two, radian_one, radian_two, line_width, color_saturation, color_value, color_cycle_speed, decay_rate;
int tempX, tempY, offset;
float radian_three, radius_three;

int control_width = 170/2;
float speed_limit = 0.4;

String keybinds = "\nKEYBINDS:\n\n\n[ h ] = hide controls\n[ r ] = reset\n[ m ] = mouse mode toggle\n[ d ] = decay toggle\n[ c ] = circles toggle\n[ l ] = lock line width\n[ s ] = save screen as PNG\n\n\n[ ARROWS ] = change speed\n\n[ SPACEBAR ] = pause\n\n[ ENTER ] = randomize!\n\n[ TAB ] = clear canvas\n\n\n\nCreated by:\nDaniel Gorelick\n\nCFA AR–388\nInteractive Design";

void setup() {
  fullScreen();
  colorMode(HSB, 360, 255, 255, 255);
  background(0, 0, 0);
  offset = width/2 + control_width;
  addSliders();
  randomize();
  initialize();
}

void draw() {
  updateGUI();

  if (paused) return;
  if (mouse_control) {
    if (tempX != mouseX && tempY != mouseY) {
      radius_one = mouseX/1.414213562;
      radius_two = mouseY/1.414213562;
    }
  }
  // increment speed and colors with draw cycle
  radian_one += speed_one;
  radian_two += speed_two;
  hue_one += color_cycle_speed;
  hue_two += color_cycle_speed;
  if (hue_one > 360) hue_one = hue_one%360;
  if (hue_two > 360) hue_two = hue_two%360;

  // "fade out" filter
  fill(0, decay_rate);
  strokeCap(SQUARE);
  noStroke();
  rect(0, 0, width, height);

  // change stroke width
  noFill();
  if (stroke_change) {
    strokeWeight(radius_two/15);
  } else {
    strokeWeight(line_width);
  }
  
  radian_three += 0.05;
  radius_three = 50;
  float centerX = offset + sin(radian_three)*radius_three;
  float centerY = height/2 + cos(radian_three)*radius_three;
  // create lines using sin and cosine
  stroke(hue_one, color_saturation, color_value, 100);
  //line(offset + sin(radian_one)*radius_one, height/2 + cos(radian_one)*radius_one, offset + sin(radian_two)*radius_two, height/2 + cos(radian_two)*radius_two);
  line(centerX + sin(radian_one)*radius_one, centerY + cos(radian_one)*radius_one, centerX + sin(radian_two)*radius_two, centerY + cos(radian_two)*radius_two);
  stroke(hue_two, color_saturation, color_value, 100);
  //line(offset + sin(radian_one + PI)*radius_one, height/2 + cos(radian_one + PI)*radius_one, offset + sin(radian_two + PI)*radius_two, height/2 + cos(radian_two + PI)*radius_two);
  line(centerX + sin(radian_one + PI)*radius_one, centerY + cos(radian_one + PI)*radius_one, centerX + sin(radian_two + PI)*radius_two, centerY + cos(radian_two + PI)*radius_two);

  // draw guiding circles 
  strokeWeight(0.5);
  if (circles) {  
    ellipse(centerX, centerY, radius_two*2, radius_two*2);
    stroke(hue_one, color_saturation, color_value, 100);
    ellipse(centerX, centerY, radius_one*2, radius_one*2);
  }
}  

void reset() {
  background(0);
}

void screenshot() {
  noFill();
  strokeWeight(1);
  stroke(0, 0, 255);
  if (!hide_controls) {
    PImage img = get(190, 20, width-210, height-40);
    img.save("frame-" + frameCount + ".png");
    rect(190, 20, width-210, height-40);
  } else {
    PImage img = get(0, 0, width, height);
    img.save("frame-" + frameCount + ".png");
    rect(0, 0, width, height);
  }
}

void initialize() {
  circles = true;
  stroke_change = true;
  hue_one = 0;
  hue_two = 240;
  speed_one = 0.12;
  speed_two = -0.04;
  color_saturation = 255;
  color_value = 255;
  color_cycle_speed = 0;
  decay_rate = 8;
}

void randomize() {
  reset();
  tempX = mouseX;
  tempY = mouseY;
  circles = (random(2)  >  1 ? true: false);
  hue_one = random(360);
  hue_two = random(360);
  speed_one = random(-speed_limit/2, speed_limit/2);
  speed_two = random(-speed_limit/2, speed_limit/2);
  radius_one = random(500);
  radius_two = random(500);
  line_width = random(1, 25);
  stroke_change = (random(0, 2) > 1) ? true : false;
  color_saturation = random(0, 255);
  color_value = random(150, 255);
  color_cycle_speed = random(0, 6);
  color_cycle_speed = (color_cycle_speed > 3) ? 0: color_cycle_speed;
  decay_rate = random(0, 10);
  if (decay_rate < 5) {
    decay_rate = 0;
  } else {
    decay_rate = 8;
  }
}

void keyPressed() {
  switch(key) {
  case ' ':
    paused = (paused ? false : true);
    break;
  case 'r': 
    reset();
    initialize();
    break;
  case 'm':
    mouse_control = (mouse_control ? false : true);
    setupSliders();
    break;
  case 'd':
    decay_rate = (decay_rate == 0 ? 8 : 0);
    break;
  case 'c':
    circles = (circles ? false : true);
    break;
  case 'l':
    stroke_change = (stroke_change ? false : true);
    break;
  case 's':
    screenshot();
    break;
  case 'h': 
    reset();
    if (hide_controls) {
      offset = width/2 + control_width;
      hide_controls = false;
    } else {
      offset = width/2;
      hide_controls = true;
    }
    setupSliders();
    break;
  case ENTER: 
    randomize();
    break;
  case TAB: 
    reset();
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

// create sliders
void addSliders() {
  cp5 = new ControlP5(this);
  cp5.addSlider("hue_one")
    .setRange(0, 360)
    .setDecimalPrecision(1)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("hue_two")
    .setRange(0, 360)
    .setDecimalPrecision(1)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("color_cycle_speed")
    .setRange(0, 10)
    .setDecimalPrecision(2)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("color_saturation")
    .setRange(0, 255)
    .setDecimalPrecision(0)
    .setValue(color_saturation)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("color_value")
    .setRange(0, 255)
    .setDecimalPrecision(0)
    .setSliderMode(Slider.FLEXIBLE);
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
  cp5.addButton("randomize");
  cp5.addSlider("line_width")
    .setPosition(-200, -200)
    .setValue(line_width)
    .setRange(1, 30)
    .setDecimalPrecision(0)
    .setSliderMode(Slider.FLEXIBLE);
  cp5.addTextlabel("label")
    .setText(keybinds);
  setupSliders();
}

int instructions_offset;
// rendering control sliders
void setupSliders() {
  reset();
  String[] sliders = new String[] {"hue_one", "hue_two", "color_cycle_speed", "color_saturation", "color_value", "speed_one", "speed_two", "radius_one", "radius_two", "randomize", "label"};
  int index = 0;
  for (int i = 0; i < sliders.length; i++) {
    if (hide_controls) {
      cp5.getController(sliders[i]).setPosition(-200, 20+40*index);
    } else {
      if (sliders[i] == "radius_one" || sliders[i] == "radius_two") {
        if (mouse_control) {
          cp5.getController(sliders[i]).setPosition(-200, 20+50*index);
        } else {
          cp5.getController(sliders[i]).setPosition(20, 20+50*index);
          index++;
        }
      } else {
        cp5.getController(sliders[i]).setPosition(20, 20+50*index);
        index++;
      }
    }
    instructions_offset = 20+50*index;
    cp5.getController(sliders[i]).setSize(150, 30);
    cp5.getController(sliders[i]).getCaptionLabel().align(cp5.LEFT, cp5.BOTTOM_OUTSIDE).setPaddingX(4);
  }
}

void updateGUI() {
  cp5.getController("hue_one").setValue(hue_one);
  cp5.getController("hue_two").setValue(hue_two);
  cp5.getController("hue_one").setColorForeground(color(hue_one, color_saturation, color_value));
  cp5.getController("hue_two").setColorForeground(color(hue_two, color_saturation, color_value));
  cp5.getController("hue_one").setColorActive(color(hue_one, color_saturation, color_value));
  cp5.getController("hue_two").setColorActive(color(hue_two, color_saturation, color_value));
  cp5.getController("speed_one").setValue(speed_one);
  cp5.getController("speed_two").setValue(speed_two);
  cp5.getController("radius_one").setValue(radius_one);
  cp5.getController("radius_two").setValue(radius_two);
  cp5.getController("color_saturation").setValue(color_saturation);
  cp5.getController("color_value").setValue(color_value);
  cp5.getController("color_cycle_speed").setValue(color_cycle_speed);
  if (stroke_change) { 
    cp5.getController("line_width").setValue(radius_two/15);
  }
  // rendering instructions w/o ControlP5
  /*if (!hide_controls) {
  //  String instructions = "KEYBINDS: \n[ h ] = hide controls\n[ r ] = reset\n[ m ] = mouse mode toggle\n[ d ] = decay toggle\n[ c ] = circles toggle\n[ l ] = lock line width\n[ s ] = save screen as PNG\n[ ARROWS ] = change speed\n[ SPACEBAR ] = pause\n[ ENTER ] = randomize!\n[ TAB ] = clear canvas\n\nCreated by:\nDaniel Gorelick\nCFA AR–388\nInteractive Design";
  //  fill(0, 0, 255);
  //  textSize(11);
  //  text(instructions, 20, height - instructions_offset, 170, instructions_offset - 20);
  }
  */
}