MercatorMap map;
Raster raster;

void setup(){
  PopPolygons = new ArrayList<Polygon>();
  size(550, 700);
  //Initialize your data structures early in setup 
  //bandra
  //map = new MercatorMap(width, height, 19.0911, 19.0402, 72.8112,72.8510, 0);
  
  //mumbai
  map = new MercatorMap(width, height, 19.2904, 18.8835,72.7364,73.0570, 0);
  
  loadData();
  parseData();
  //raster = new Raster(20, 600, 600);
}

void draw(){
  background(0);
  
  for(int i=0; i<PopPolygons.size(); i++){
    PopPolygons.get(i).draw();
  }
  
  
  for(int i=0; i<kData.getRowCount()-1; i++){
    k_array.get(i).draw();
  }
  
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
  
  for(int i=0; i<transportData.getRowCount()-1; i++){
    //println(transport_ways); 
    //transport_ways.get(i).draw();
  }
  
  
  
  //raster.draw();
  block.draw();
  drawInfo();
  
}
