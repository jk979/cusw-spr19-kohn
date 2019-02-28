//make blank map

//goal: map with capabilities: 
//restaurant: press R to show restaurants
//free food: press F to load free food on campus
//seasons of free food: press 1 for spring set, 2 for summer set, 3 for fall set, 4 for winter set
//buildings: press B to show building layer

int key_press_f = 0;

MercatorMap map;
PImage background;

//create buttons
boolean button_food = false;
boolean button_restaurant = false;
boolean button_roads = false;


void setup(){
  size(1000,650);
  
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
  
}

void draw(){
  //draw background image and make it size of screen
  //image(background,0,0);
  fill(0,180);
  rect(0,0,width,height);
  
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
  
  //draw legend
  drawInfo();
  //draw instructions box
  drawCount();
  
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
}
  
void drawCount() {
  //instructions 1
  fill(250, 250, 100); //title color
  textSize(16); //title text size
  text("Free Food Chase",600,420);
  //instructions
  fill(250,250,50);
  textSize(14);
  text("Toggle Layers:\nf: free food\nr: restaurants\ns: streets", 600, 520); //text placement
  fill(250,250,100);
  text("Use the arrow keys to race to the food\nas it appears at each establishment!",600,450);
  
  /*
  //score
  stroke(180,180,180);
  fill(255,0,255);
  text("Free Food Collected: " + k.len, width/100, 80);
  */
}

/*
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
  */
