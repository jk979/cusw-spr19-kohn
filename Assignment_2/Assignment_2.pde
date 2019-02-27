//make blank map

MercatorMap map;
PImage background;

void setup(){
  size(850,650);
  
  //Initialize data structures
  //big mit map
  //map = new MercatorMap(width, height, 42.3557, 42.3636, -71.0869,-71.1034,0);

  //small mit map
  map = new MercatorMap(width, height, 42.3561,42.3655, -71.0973,-71.0813,0);
  pois = new ArrayList<POI>();
  polygons = new ArrayList<Polygon>();
  //ways = new ArrayList<Way>();
  
  loadData();
  parseData();
  
}

void draw(){
  //draw background image and make it size of screen
  image(background,0,0);
  fill(0,120);
  rect(0,0,width,height);
  
  //draw each of the polygons
  for(int i = 0; i<polygons.size(); i++){
    polygons.get(i).draw();
  }
  
  //draw each poi
  for(int i = 0; i<pois.size(); i++){
    pois.get(i).draw();
  }
  
  drawInfo();
}
