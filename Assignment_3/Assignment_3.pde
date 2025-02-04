MercatorMap map;
Raster raster;
Heatmap heatmap;
float cellWidth = 10;
float cellHeight = 10;
int numXCells, numYCells;
boolean button_k = false;
boolean button_mrf = false;


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
  makeFakeHeatmap();
  //raster = new Raster(20, 600, 600);
}

void keyPressed(){
  if(key=='k'){
    println("button_pressed");
    button_k = !button_k;
    println("button k is" +button_k);
  }
  if(key=='m'){
    button_mrf = !button_mrf;
  }
}


void draw(){
  background(0);
  
  //draw population polygons
  for(int i=0; i<PopPolygons.size(); i++){
    PopPolygons.get(i).draw();
    
  }
  
 
    
  //image(heatmap.p, 0, 0);
  
  //draw mrfs
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
  
   //draw kabadiwalas
    for(int i=0; i<kData.getRowCount()-1; i++){
      k_array.get(i).draw();
    }

  
  //draw outline
  //outline_city.draw();
  
  //draw wards
  //outline_wards.draw();


  //draw transport
  /*
  for(int i=0; i<ways.size(); i++){
    //println(transport_ways); 
    ways.get(i).draw();
  }
  */
  
  //raster.draw();
  drawInfo();
  
  noLoop();
}
