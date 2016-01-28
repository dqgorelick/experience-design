//int w = 600;
//int h = 600;
//int step = 5;
//void setup() {
// size(600,600);
// background(255);
//}

//void draw() { 
// float a = 0.0;
// float inc = TWO_PI/(600/step);
// for(int i = 0; i < 600; i+=step) {
//   //stroke(255, 0, 0);
//   //line(i, 300, i, 300 + (sin(a) * 300));
//   //stroke(0, 0, 255);
//   //line(i+step/2, 300, i+step/2, 300 + (cos(a) * 300));
    
//   //stroke(255, 0, 0);
//   //line(i, 300, i, 300 + (sin(a+PI) * 300));
//   //stroke(0, 0, 255);
//   //line(i+step/2, 300, i+step/2, 300 + (cos(a+PI) * 300));
//   a += inc;   
// }
//}

int lastX, lastY;
float rad = 0.0;
float inc = TWO_PI/(200);

void setup() {
  size(600,600);
  background(255);
}

void draw() {
  
  if(mouseX != lastX && mouseY != lastY) {    
    fill(sin(rad)*255,100,cos(rad)*255);
    noStroke();
    ellipse(mouseX, mouseY, 60 + sin(rad)*30, 60 + sin(rad)*30);
    lastX = mouseX;
    lastY = mouseY;
    rad += inc;
    fill(255,255,255,0.1);
  }
}