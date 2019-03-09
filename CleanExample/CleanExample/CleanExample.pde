MercatorMap map;
Raster raster;

void setup(){
  CensusPolygons = new ArrayList<Polygon>();
  size(600, 800);
  //Intiailize your data structures early in setup 
  map = new MercatorMap(width, height, 19.2904, 18.8835,72.7364,73.0570, 0);
  loadData();
  parseData();
  raster = new Raster(20, 600, 600);
}

void draw(){
  background(255);
  
  for(Polygon p : CensusPolygons){
    p.draw();
  }
  
//  raster.draw();
    
}
