Table CountyBoundary;
Table CensusData;
Table CensusBlocks;


void loadData(){
  CensusBlocks = loadTable("data/Nodes.csv", "header");
  CensusData = loadTable("data/Attributes.csv", "header");
  println("Data Loaded");
}
ArrayList coords;
void parseData(){
  
  //Now we can parse the population polygons! 
  int previd = 0;
  coords = new ArrayList<PVector>();
  for(int i =0; i<CensusBlocks.getRowCount(); i++){
    int shapeid = int(CensusBlocks.getString(i, 0));
    if(shapeid != previd){
      if(coords.size() >0){
        Polygon poly = new Polygon(coords);
        poly.id = shapeid;
        CensusPolygons.add(poly);
      }
      //reset and clear
      coords = new ArrayList<PVector>();
      previd = shapeid;
    }
    if(shapeid == previd){
      float lat = float(CensusBlocks.getString(i, 2));
      float lon = float(CensusBlocks.getString(i, 1));
      coords.add(new PVector(lat, lon));
    }
  }
  
  //Add an attribute! 
  for(int i =0; i<CensusPolygons.size(); i++){
    CensusPolygons.get(i).score = map(CensusData.getFloat(i, "TOT_POP"), 0, 760573, 255, 0);
    CensusPolygons.get(i).colorByScore();
    CensusPolygons.get(i).makeShape();
  }
  println("Data Parsed");
}
