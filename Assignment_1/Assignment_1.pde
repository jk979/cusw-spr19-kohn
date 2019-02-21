float[] x = new float[1];
float[] y = new float[1];
float segLength = 50; //how long to make agent segment
float num_garbages = 10; //number of garbage balls
float num_background_changes = 0; //number of times background changed
float m = 0;

Garbage garbage1;
Agent k;
int pickupCount;

ArrayList<GarbageInert> garbages;
ArrayList<Agent> kabadiwala;

void setup() {
  size(640, 360);

  strokeWeight(9);
  frameRate(60);
  stroke(255, 100);
  pickupCount = 0;

  k = new Agent(30);
  garbage1 = new Garbage();

  //make an add-able array of garbages
  garbages = new ArrayList<GarbageInert>();
  for (int i=0; i<num_garbages; i++) {
    GarbageInert a = new GarbageInert(200, 200, 20);
    a.reset();
    garbages.add(a);
  }
}

void draw() {
  background(0);
  
  drawCount();
  //Agent movements
  k.move();
  k.display();
  garbage1.display();

  //Garbageball movements
  for (GarbageInert b : garbages) {
    b.update();
    b.drawGarbage();

    if ( dist(garbage1.xpos, garbage1.ypos, k.xpos.get(0), k.ypos.get(0)) < k.sidelen ) {
      garbage1.reset();
      k.addLink();
    }
    if (dist(b.screenLocation.x, b.screenLocation.y, k.xpos.get(0), k.ypos.get(0)) == k.sidelen){
     b.update();
    }
  }
}

//if key pressed, make Agent move
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      k.dir = "left";
    }
    if (keyCode == RIGHT) {
      k.dir = "right";
    }
    if (keyCode == UP) {
      k.dir = "up";
    }
    if (keyCode == DOWN) {
      k.dir = "down";
    }
    } else if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
    int keyIndex;
    if(key <= 'z') {
      keyIndex = key-'A';
      m = random(200,250);
      background(50,250,250);
      num_background_changes++;
    } else {
      background(50, 0, 250);
      }
    }
}

void mousePressed() {
  for (GarbageInert g : garbages) {
    if (g.checkSelection()) {
      break;
    }
  }
}

void mouseReleased() {
  for (GarbageInert g : garbages) {
    g.locked = false;
  }
}

void drawCount() {
  //instructions 1
  fill(250, 250, 100); //title color
  textSize(14); //title text size
  text("KabadiwalaConsume: Move the square with arrow keys" + "\n" + "and catch the blue garbage particles", width/1000, 20); //text placement
  
  //instructions 2
  fill(250, 250, 80); //title color
  textSize(14); //title text size
  text("Rearrange the inert particles thru click-and-drag", width/1000, 60); //text placement
  
  //score
  stroke(180, 180, 180);
  fill(255, 0, 255);
  //rect(50, 50, 50, 50);
  fill(250, 20, 170);
  textSize(11);
  text("Garbage Particles Collected: " + k.len, width/100, 80);
  
  //Framerate
  fill(250, 20, 200);
  textSize(11);
  text("Framerate: " + frameRate, width/100, 100);
  
  //author
  fill(250, 0, 100);
  textSize(10);
  text("By Jacob Kohn", width/1000, 140);
  
  //Background Changes
  fill(250, 20, 200);
  textSize(11);
  text("Press any alphabetic key to flash the background! #keypresses: " + num_background_changes, width/100, 120);
}
