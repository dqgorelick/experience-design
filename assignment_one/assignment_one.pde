int rate = 20; //speed of the iterations 
int shapes = 17; // change based on number of shapes
float color_inc = TWO_PI/(2000); // change rate of background of background color
int count = 0;
int marker = 0;
boolean direction = true;
float rad = random(100)/100;

void setup() {
  size(500, 500);
}

void drawShape(int hue, int starter) {
  if (marker >= starter) {
    fill(hue);
  } else {
    noFill();
    noStroke();
  }
}

void draw() {
  count++;
  rad += color_inc;
  if (marker == shapes+1) {
    direction = false;
  }
  if (marker == -1) {
    direction = true;
  }
  if (count % 20 == 0 ) {
      println(count);
  }
  if (count % rate == 0) {
    marker = direction ? ++marker : --marker;
  }
  clear();
  background(sin(rad)*200, 125, cos(rad)*200);

  drawShape(192, 1);
  beginShape();
  vertex(133, 56);
  vertex(378, 56);
  vertex(378, 200);
  vertex(133, 200);
  endShape(CLOSE);

  drawShape(127, 2);
  beginShape();
  vertex(335, 300);
  vertex(426, 208);
  vertex(350, 156);
  endShape(CLOSE);

  drawShape(192, 3);
  beginShape();
  vertex(257, 461);
  vertex(146, 367);
  vertex(181, 165);
  endShape(CLOSE);

  drawShape(113, 4);
  beginShape();
  vertex(259, 473);
  vertex(166, 199);
  vertex(299, 195);
  endShape(CLOSE);

  drawShape(85, 5);
  beginShape();
  vertex(108, 113);
  vertex(200, 113);
  vertex(200, 340);
  vertex(108, 340);
  endShape(CLOSE);

  drawShape(255, 6);
  shapeMode(CENTER);
  ellipse(111, 189, 124, 124);
  shapeMode(CORNER);

  drawShape(255, 7);
  beginShape();
  vertex(280, 319);
  vertex(148, 319);
  vertex(148, 360);
  vertex(281, 361);
  endShape(CLOSE);

  drawShape(10, 8);
  beginShape();
  vertex(173, 336);
  vertex(300, 336);
  vertex(300, 340);
  vertex(173, 340);
  endShape(CLOSE);

  drawShape(174, 9);
  beginShape();
  vertex(66, 278);
  vertex(446, 45);
  vertex(306, 278);
  endShape(CLOSE);

  drawShape(46, 10);
  beginShape();
  vertex(252, 233);
  vertex(381, 233);
  vertex(381, 422);
  vertex(252, 422);
  endShape(CLOSE);

  drawShape(174, 11);
  beginShape();
  vertex(302, 296);
  vertex(315, 314);
  vertex(350, 314);
  vertex(325, 337);
  vertex(346, 370);
  vertex(316, 347);
  vertex(291, 377);
  vertex(297, 338);
  vertex(274, 320);
  vertex(298, 314);
  endShape(CLOSE);

  drawShape(255, 12);
  shapeMode(CENTER);
  ellipse(336, 230, 56, 56);
  shapeMode(CORNER);

  drawShape(87, 13);
  shapeMode(CENTER);
  ellipse(158, 267, 10, 10);
  shapeMode(CORNER);

  drawShape(150, 14);
  shapeMode(CENTER);
  ellipse(120, 270, 8, 8);
  shapeMode(CORNER);

  drawShape(10, 15);
  beginShape();
  vertex(336, 250);
  vertex(329, 250);
  vertex(329, 222);
  vertex(336, 222);
  endShape(CLOSE);

  drawShape(10, 16);
  beginShape();
  vertex(111, 227);
  vertex(111, 161);
  vertex(101, 161);
  vertex(101, 227);
  endShape(CLOSE);
}