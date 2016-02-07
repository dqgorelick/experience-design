int clouds = 5;
int speed = 10;

// too lazy to make this into a class
int[] xs = new int[clouds];
int[] colors = new int[clouds];
int[] ys = new int[clouds];
int[] widths = new int[clouds];
float[] incs = new float[clouds];
float[] periods = new float[clouds];

void setup() {
  fullScreen();
  background(255);
  for (int i = 0; i < clouds; i++) {
    xs[i] = i*-100;
  }
}


void draw() {
  noStroke();
  fill(0, 0, 255, 1);
  for( int i = 0; i < clouds; i++ ){
    // re-init cloud options
    if (xs[i] == 0) {
      ys[i] = floor(random(height));
      widths[i] = floor(random(80, 150));
      incs[i] = random(0.1,0.3);
      periods[i] = random(0,1);
      colors[i] = floor(random(0,255));
    }  
    // draw each cloud
    
    fill(colors[i],10);
    periods[i] += incs[i];
    xs[i] += speed;
    for(int j = 0; j < speed; j++) {
      ellipse(xs[i]+j, (sin(periods[i])*widths[i]/3) + ys[i], widths[i], widths[i]);
    }
    if(xs[i] > width) {
      xs[i] = 0;
    }
  }
}