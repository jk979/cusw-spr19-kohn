//make blank map

//goal: map with capabilities: 
//restaurant: press R to show restaurants
//free food: press F to load free food on campus
//seasons of free food: press 1 for spring set, 2 for summer set, 3 for fall set, 4 for winter set

//game begin
float[] x = new float[1];
float[] y = new float[1];
int euclidean;
float segLength = 50; //how long to make agent segment
PImage pierreSize;
int pierreSizeSide;
boolean pierreFull;


//initialize timer
//PFont font;
String time = "00:10";
int t;
int interval = 10;

Garbage garbage1;
Agent k;
int pickupCount;

//ArrayList<GarbageInert> garbages;
ArrayList<Agent> kabadiwala;

MercatorMap map;
PImage background;

//create buttons
boolean button_food = false;
boolean button_restaurant = false;
boolean button_roads = false;


void setup(){
  size(1000,650);
  pickupCount = 0;
  frameRate = 40;
  pierreSize = loadImage("data/pierre.png");
  pierreFull = false;
  
  //k = new Agent(30);
  //garbage1 = new Garbage();
  
  //Initialize data structures
  //big mit map
  //map = new MercatorMap(width, height, 42.3557, 42.3636, -71.0869,-71.1034,0);

  //small mit map
  map = new MercatorMap(width, height, 42.3644,42.3550,-71.0990,-71.0795,0);
  pois = new ArrayList<POI>();
  polygons = new ArrayList<Polygon>();
  foods = new ArrayList<FoodPOI>();
  ways = new ArrayList<Way>();
  
  loadData();
  parseData();
  
    k = new Agent(30);
  garbage1 = new Garbage();
  
  
}

void draw(){
  //draw background image and make it size of screen
  //image(background,0,0);
  fill(0,180);
  rect(0,0,width,height);
  //pierreSizeSide = 50;
  
  //draw roads
  if(button_roads){
    for(int i = 0; i<ways.size(); i++){
      ways.get(i).draw();
    } 
  }
  
  //draw building polygons
  for(int i = 0; i<polygons.size(); i++){
        polygons.get(i).draw();
      }
   
  //draw restaurants
  if(button_restaurant){
    for(int i = 0; i<pois.size(); i++){
      pois.get(i).draw();
    }
  }
  
  //draw free food
  if(button_food){
      for(int i = 0; i<foods.size(); i++){
        foods.get(i).draw();
      }
  }
  
  //pick random value from arraylist FoodPOI
  
   
  //draw legend
  drawInfo();
  //draw instructions box
  drawCount();
  
  k.move();
  k.display();
  garbage1.display();
  image(pierreSize,500,540,pierreSizeSide,pierreSizeSide);

  
  fill(255,255,255);
  textSize(16);
  text("Time until Food Moved:",600,550);
  t = interval-int(millis()/1000);
  time = nf(t , 2);
  if(t >=4){
    fill(255,255,255);
    textSize(36);
  }
  else if(t==3){
    fill(255,255,0);
    textSize(36);
  }
  else if(t==2){
    fill(255,140,0);
    textSize(36);
  }
  else if(t==1){
    fill(255,0,0);
    textSize(36);
  }
  if(t == 0){
    fill(255,20,147);
    textSize(36);
    println("Free Food Moved!");
    garbage1.reset();
    interval+=10;
  }
  text("00:"+time, 600, 590);
  
  //distance and collision measurement
   euclidean = parseInt(dist(garbage1.xpos, garbage1.ypos, k.xpos.get(0), k.ypos.get(0)));
    if (euclidean < (k.sidelen + garbage1.radius) ) {
      pierreSizeSide = pierreSizeSide+10;
      garbage1.reset();
      k.addLink();
      
      //b.update();
    }
    
    if(pierreSizeSide >=40){
      pierreFull = true;
      fill(255,0,0);
      textSize(80);
      text("PIERRE IS FULL!",200,325);
    }
    
  //}
  
}
void keyPressed(){
  if(key=='f'){
    button_food = !button_food;
  }
  if(key=='r'){
    button_restaurant = !button_restaurant;
  }
  if(key=='s'){
    button_roads = !button_roads;
  }
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
  }
}
  
void drawCount() {
  //instructions 1
  fill(255, 255, 255); //title color
  textSize(24); //title text size
  text("Free Food Chase \n      @ MIT",600,420);
  //instructions
  fill(250,250,250);
  textSize(18);
  text("Legend",830,420);
  fill(255,255,255);
  textSize(14);
  text("----------------",830,560);
  fill(250,250,50);
  textSize(14);
  text("Toggle Layers:\nf: free food\nr: restaurants\ns: streets", 830, 580); //text placement
  fill(250,250,100);
  text("Help Pierre consume the \nfree food by using the arrow \nkeys to race to food locations!",600,480);
  
  fill(255,255,255);
  textSize(10);
  text("Pierre's Current \nStomach Size:",500,510);
  
  //score
  stroke(180,180,180);
  fill(255,255,255);
  text("Free Food Collected: " + (parseInt(k.len)-1), 600,610);
  
  //Framerate or distance to food
  fill(128,128,128);
  textSize(11);
  text("Distance to food: "+euclidean,600,625);
  //text("Framerate: " + frameRate, 600, 625);
  
  //author
  fill(128,128,128);
  textSize(10);
  text("By Jacob Kohn", 600, 640);
}


  
  
  
  
