Table MumbaiWardBoundary, PopBlocks, PopData, kData;

void loadData(){
  MumbaiWardBoundary = loadTable("data/mumbai_outline-nodes.csv", "header");
  PopBlocks = loadTable("data/mumbai_pop2011-nodes.csv", "header");
  PopData = loadTable("data/mumbai_pop2011-attributes.csv", "header");
  kData = loadTable("data/k_short.csv", "header");
  println("Data loaded");
}

void parseData(){
  //first, parse the ward polygons
  ArrayList<PVector> coords = new ArrayList<PVector>();
  //get lat and lon from Ward Boundary CSV
  for(int i=0; i<MumbaiWardBoundary.getRowCount(); i++){
    float lat = float(MumbaiWardBoundary.getString(i,2));
    float lon = float(MumbaiWardBoundary.getString(i,1));
    //add them to new PVector
    coords.add(new PVector(lat, lon));
  }
  
  block = new Polygon(coords);
  block.outline = true; 
  block.makeShape();
  
  //parse population polygons
  int previd = 0; 
  coords = new ArrayList<PVector>();
  for(int i = 0; i<PopBlocks.getRowCount(); i++){
    //get shapeid for joining
    int shapeid = int(PopBlocks.getString(i, 0));
    if(shapeid != previd){
      if(coords.size() > 0){
        Polygon poly = new Polygon(coords);
        poly.id = shapeid; 
        PopPolygons.add(poly);
      }
      //clear coords
      coords = new ArrayList<PVector>();
      //reset variable
      previd = shapeid;
    }
    if(shapeid == previd){
      float lat = float(PopBlocks.getString(i,2));
      float lon = float(PopBlocks.getString(i,1));
      //println(lat, lon);
      coords.add(new PVector(lat,lon));
    }
  }
  
  //add attribute of the polygon
   for(int i = 0; i<PopPolygons.size(); i++){
    PopPolygons.get(i).score = PopData.getFloat(i, "TOT_POP"); //this is ONLY if the IDs are accurate
    PopPolygons.get(i).colorByScore();
    PopPolygons.get(i).makeShape();
  }
  
  //parse CSV
  int previd_k = 0; 
  ArrayList<PVector> kcoords = new ArrayList<PVector>();
  float lat_k, lon_k;
      
  for(int i = 0; i<kData.getRowCount(); i++){
    
    lat_k = float(kData.getString(i,2));
    println(lat_k);
    lon_k = float(kData.getString(i,3));
    println(lon_k);
    
    int k_id = int(kData.getString(i,0));
      if(k_id != previd_k){
        if(kcoords.size() > 0){ //create constructor for kcoords
          Point_k k = new Point_k(lat_k,lon_k);
          k_array.add(k);
          println(k_array);
        }
        //clear coords
        kcoords = new ArrayList<PVector>();
        //reset variable
        previd_k = k_id;
      }
      if(k_id == previd_k){
        float lat_kmatch = float(kData.getString(i,2)); //west
        float lon_kmatch = float(kData.getString(i,3));
        kcoords.add(new PVector(lat_kmatch, lon_kmatch));
      }
  }
  
  
  //
  println("Data Parsed");
}
