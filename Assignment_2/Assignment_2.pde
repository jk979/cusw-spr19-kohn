//make blank map

//goal: map with capabilities: 
//restaurant: press R to show restaurants
//free food: press F to show free food on campus
//seasons of free food: press 1 for spring set, 2 for summer set, 3 for fall set, 4 for winter set
//buildings: press B to show building layer

int key_press_b = 0;

MercatorMap map;
PImage background;

void setup(){
  size(850,700);
  
  //Initialize data structures
  //big mit map
  //map = new MercatorMap(width, height, 42.3557, 42.3636, -71.0869,-71.1034,0);

  //small mit map
  //map = new MercatorMap(width, height, 42.3636, 42.3557, -71.1034, -71.0869, 0);
  map = new MercatorMap(width, height, 42.3655, 42.3561, -71.0973, -71.0813,0);
  pois = new ArrayList<POI>();
  polygons = new ArrayList<Polygon>();
  foods = new ArrayList<FoodPOI>();
  //ways = new ArrayList<Way>();
  
  loadData();
  parseData();
  
}

void draw(){
  //draw background image and make it size of screen
  //image(background,0,0);
  fill(0,120);
  rect(0,0,width,height);
  
  for(int i=0; i<foods.size();i++){
    foods.get(i).draw();
  }
  drawInfo();
  
  for(int i = 0; i<polygons.size(); i++){
        polygons.get(i).draw();
      }
   
  for(int i = 0; i<pois.size(); i++){
    pois.get(i).draw();
  }
    
  for(int i = 0; i<foods.size(); i++){
    foods.get(i).draw();
  }
  


}
void keyPressed(){
  if(key=='b'){
    key_press_b++;
    //if key_press_b is odd: 
    if(key_press_b % 2 == 0){
    //draw each of the polygons
    for(int i = 0; i<polygons.size(); i++){
      polygons.get(i).draw();
    }
   
  }
  else{
    //if key_press_b is even: 
    //remove layer and reset to background
    println(0);
  }
  
  
  /*
  //draw each poi
  for(int i = 0; i<pois.size(); i++){
    pois.get(i).draw();
  }
  */
}
}
