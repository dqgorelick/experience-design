float rotx = PI/4;
float roty = PI/4;
int d2 = 60;
int rate = 60;
int[] sides = new int[] {0,1,2,3,2,6,7,3,6,7,4,5,4,5,1,0,1,2,6,5,0,3,7,4};
float[] x = new float[] {-2,-2, 2, 2,-2,-2, 2, 2,-1,-1, 1, 1,-1,-1, 1, 1};
float[] y = new float[] {-2,-2,-2,-2, 2, 2, 2, 2,-1,-1,-1,-1, 1, 1, 1, 1};
float[] z = new float[] { 2,-2,-2, 2, 2,-2,-2, 2, 1,-1,-1, 1, 1,-1,-1, 1};
float[] x1 = new float[8];
float[] y1 = new float[8];
float[] z1 = new float[8];
float angle = 0;
float speed = 60;
boolean clicked = true;

void mouseClicked() {
 clicked = true;
 println(mouseX, mouseY);
}

void setup(){
  size(600, 600, P3D);
  background(255);
}

void draw() {
  translate(width/2, height/2, 100);
  background(255);
  rotateX(-PI/5 + (angle/speed)*(-PI/2));
  rotateY((angle/speed)*(-PI/2));
  rotateX(rotx);
  rotateY(roty);
  angle++;
  if(clicked || angle%180 == 0) {
    for(int i = 0; i < 8; i++) {
      x1[i] = random((x[i] < 0 ? (-2) : (0.2)),(x[i] < 0 ? (-0.2) : (2)));
      y1[i] = random((y[i] < 0 ? (-2) : (0.2)),(y[i] < 0 ? (-0.2) : (2)));
      z1[i] = random((z[i] < 0 ? (-2) : (0.2)),(z[i] < 0 ? (-0.2) : (2)));
    }
    clicked = false;
  }
  noStroke();
  fill(200);
  lights();
  spotLight(51, 102, 126, 80, 20, 40, -1, 0, 0, PI/2, 2);
  beginShape(QUADS);
  for (int i = 0; i < sides.length; i++) {
    vertex(d2*x1[sides[i]],d2*y1[sides[i]],d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(-d2*x1[sides[i]],-d2*y1[sides[i]],-d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(-d2*x1[sides[i]],d2*y1[sides[i]],-d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(-d2*x1[sides[i]],-d2*y1[sides[i]],d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(d2*x1[sides[i]],-d2*y1[sides[i]],-d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(d2*x1[sides[i]],-d2*y1[sides[i]],d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(-d2*x1[sides[i]],d2*y1[sides[i]],d2*z1[sides[i]]);
  }
  for (int i = 0; i < sides.length; i++) {
    vertex(d2*x1[sides[i]],d2*y1[sides[i]],-d2*z1[sides[i]]);
  }
  endShape();
  fill(0);
}