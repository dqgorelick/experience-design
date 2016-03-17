import ddf.minim.*;

Minim minim;
// change song file to add your own!
AudioPlayer song;
AudioInput in; 

int linesX = 40; // number of lines in x direction
int linesY = 26; // number of lines in y direction

boolean repel = true;
boolean autopilot = false;
boolean paused = false;
boolean controls = true;
boolean voice = false;
int coef = 1;
int mode = 0;
float magnitude = 0;
float maxMagnitude = 848.5281374;

color c;
PVector distance;
PFont sourcecode;
float stepsX, stepsY, radius, intensity, movement, last_sum, scale, factor, wave, sum;

class Node { 
  float xpos, ypos, speed, anchorx, anchory;
  Node (float x, float y, float s) {  
    anchorx = x;
    anchory = y;
    ypos = y; 
    xpos = x;
    speed = s;
  }
}

Node[][] Nodes = new Node[linesX][linesY]; // create matrix of Nodes 

class Fish {
  float xpos, ypos, speed;
  Fish () {  
    ypos = random(800*0.25, 800*0.75); 
    xpos = random(1000*0.25, 1000*0.75);
  }
  void update() {
    //increase movement w/ volume of song
    xpos = lerp(xpos + random(sum/20) - sum/40, xpos, 0.5); 
    ypos = lerp(ypos + random(sum/20) - sum/40, ypos, 0.5); 
    if (ypos > height*0.75) {
      ypos = height*0.75;
    } else if (xpos > width*0.75) {
      xpos = width*0.75;
    } else if (xpos < width*0.25) {
      xpos = width*0.25;
    } else if (ypos < height*0.25) {
      ypos = height*0.25;
    }
  }
}

Fish jimmy = new Fish(); //create Jimmy

void setup() {
  fullScreen();
  colorMode(HSB, 255);
  stepsX = (width) / linesX;
  stepsY = (height) / linesY;
  // initialize nodes
  for (int i = 0; i < linesX; i++) {
    for (int j = 0; j < linesY; j++) {
      Nodes[i][j] = new Node((i+0.5)*stepsX, (j+0.5)*stepsY, 2);
    }
  }
  minim = new Minim(this);
  song = minim.loadFile("Jack Garratt - The Love Youre Given.mp3");
  in = minim.getLineIn(Minim.MONO, 1024);
  song.play(73*1000+500);
  factor = float(width)/song.bufferSize();
  textAlign(LEFT);
  sourcecode = createFont("sourcecode.ttf", 100);
}


void keyPressed() {
  switch(key) {
  case ' ':
    repel = !repel;
    break;
  case 'm':
    mode += 1;
    if (mode > 1) {
      mode = 0;
    }
    break;
  case 'a':
    autopilot = !autopilot;
    break;
  case 'p':
    paused = !paused;
    if (!paused) {
      song.play();
      voice = false;
    } else if (paused) {
      song.pause();
      voice = false;
    }
    break;
  case 's':
    saveFrame("wavepttrn-####.jpg");
    break;
  case 'h':
    controls = !controls;
    break;
  case 'v': 
    voice = !voice;
    if (!voice) {
      song.play();
      paused = false;
    } else{
      song.pause();
      paused = true;
    }
    break;
  }
}

void draw() {
  background(frameCount%255, 255, 30);
  coef = (repel ? 1 : -1);
  //if (paused) {
  // movement = (abs(mouseX - pmouseX) + abs(mouseY- pmouseY));
  // magnitude = lerp(magnitude, movement, 0.1);
  // wave = 0;
  //} else {
    magnitude = lerp(sum, last_sum, 0.7)/2.5;
    wave = last_sum/2.5;
  //}
  // draw nodes
  for (int i = 0; i < linesX; i++) {
    for (int j = 0; j < linesY; j++) {
      if (autopilot) {
        jimmy.update();
        distance = new PVector(Nodes[i][j].xpos - jimmy.xpos, Nodes[i][j].ypos - jimmy.ypos);
      } else { 
        distance = new PVector(Nodes[i][j].xpos - mouseX, Nodes[i][j].ypos - mouseY);
      }
      scale = (1/distance.mag())*magnitude;
      fill(255);
      intensity = pow(1 - distance.mag()/(maxMagnitude), 5);
      radius = (intensity*magnitude);
      Nodes[i][j].xpos += coef*(distance.x*scale)/25;
      Nodes[i][j].ypos += coef*(distance.y*scale)/25;
      Nodes[i][j].xpos = lerp(Nodes[i][j].xpos, Nodes[i][j].anchorx, 0.05);
      Nodes[i][j].ypos = lerp(Nodes[i][j].ypos, Nodes[i][j].anchory, 0.05);
      if (radius > 50) {
        radius = 50;
      }
      if (radius < 2) {
        radius = 2;
      }
      c = color(170 + magnitude/2, magnitude*5, 255, 255); 
      fill(c);
      stroke(c);
      if (mode == 0) {
        ellipse(Nodes[i][j].xpos + coef*(distance.x*scale), Nodes[i][j].ypos + coef*(distance.y*scale), radius, radius);
      }
      if (mode == 1) {
        strokeWeight(radius/3);
        strokeCap(PROJECT);
        line(Nodes[i][j].xpos + coef*(distance.x*scale), Nodes[i][j].ypos + coef*(distance.y*scale), Nodes[i][j].xpos, Nodes[i][j].ypos);
      }
    }
  }
  // draw wave code 
  c = color(170 + wave/2, wave*5, 255, 255); 
  fill(c);
  stroke(c);
  strokeWeight(2);
  sum = 0; //increase sum based on amplitude of wave
  for (int i = 0; i < song.bufferSize() - 1; i++)
  {
    if(voice) {
      line(i*factor, height/2 + in.left.get(i)*last_sum + 2, i*factor+1, height/2 + in.left.get(i+1)*last_sum + 2);
      sum += abs(in.left.get(i));
    } else {
      line(i*factor, height/2 + song.left.get(i)*last_sum + 2, i*factor+1, height/2 + song.left.get(i+1)*last_sum + 2);
      sum += abs(song.left.get(i));
    }
  }
  last_sum = sum;

  // HUD controls
  if (controls) {
    fill(255, 0, 255);
    textFont(sourcecode);
    textSize(18);
    text("[ space ] = alter gravity\n[ m ] = change mode\n[ p ] = pause music\n[ a ] = autopilot\n[ s ] = save frame\n[ v ] = voice mode\n[ h ] = hide controls", 20, 40);
  }
}