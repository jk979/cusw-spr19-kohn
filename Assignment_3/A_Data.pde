Table MumbaiOutline, MumbaiWardBoundary, PopBlocks, PopData, kData, mrfData,transportNodes,transportData;
JSONObject roads_json;
JSONArray line_features;

void loadData(){
  roads_json = loadJSONObject("data/mumbai_streetnetwork.json");
  line_features = roads_json.getJSONArray("geometries");

  MumbaiOutline = loadTable("data/mumbai_outline-nodes.csv", "header");
  MumbaiWardBoundary = loadTable("data/mumbai_wards-nodes.csv","header");
  PopBlocks = loadTable("data/mumbai_pop2011-nodes.csv", "header");
  PopData = loadTable("data/mumbai_pop2011-attributes.csv", "header");
  kData = loadTable("data/k_short.csv", "header");
  mrfData = loadTable("data/mrf_formatted.csv", "header");
  transportData = loadTable("data/mumbai_transport-western-nodes.csv","header");
  //transportData = loadTable("data/mumbai_transport-western-attributes.csv","header");
  //load streets
  
  println("Data loaded");
}

void parseData(){
  
  //1. parse the ward polygons
  ArrayList<PVector> coords = new ArrayList<PVector>();
  //get lat and lon from Ward Boundary CSV
  for(int i=0; i<MumbaiWardBoundary.getRowCount(); i++){
    float lat = float(MumbaiWardBoundary.getString(i,2));
    float lon = float(MumbaiWardBoundary.getString(i,1));
    //add them to new PVector
    coords.add(new PVector(lat, lon));
  }
  
  outline_wards = new Polygon(coords);
  outline_wards.cityOutline = false; 
  outline_wards.wardOutline = true;
  outline_wards.makeShape();
  
  //2. parse population polygons
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
      coords.add(new PVector(lat,lon));
    }
  }
  
  //add attribute of the polygon
   for(int i = 0; i<PopPolygons.size(); i++){
    PopPolygons.get(i).score = PopData.getFloat(i, "pop_km");
    println("pop per km is " + PopPolygons.get(i).score);
    PopPolygons.get(i).colorByScore();
    PopPolygons.get(i).makeShape();
  }
  
   //get lat and lon from Outline CSV
  ArrayList<PVector> outline_coords = new ArrayList<PVector>();
  for(int i=0; i<MumbaiOutline.getRowCount(); i++){
    float lat = float(MumbaiOutline.getString(i,2));
    float lon = float(MumbaiOutline.getString(i,1));
    //add them to new PVector
    outline_coords.add(new PVector(lat, lon));
  }
  
  outline_city= new Polygon(outline_coords);
  outline_city.cityOutline = true; 
  outline_city.makeShape();
  
  //parse CSV for k
  int previd_k = 0; 
  ArrayList<PVector> kcoords = new ArrayList<PVector>();
  float lat_k, lon_k;
  for(int i = 0; i<kData.getRowCount(); i++){
    lat_k = float(kData.getString(i,2));
    lon_k = float(kData.getString(i,3));
    int k_id = int(kData.getString(i,0));
      if(k_id != previd_k){
        if(kcoords.size() > 0){ //create constructor for kcoords
          Point_k k = new Point_k(lat_k,lon_k);
          k.typeK = true;
          k_array.add(k);
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
  
  //parse CSV for MRF
  int previd_mrf = 0; 
  ArrayList<PVector> mrfcoords = new ArrayList<PVector>();
  float lat_mrf, lon_mrf;
  for(int i = 0; i<mrfData.getRowCount(); i++){
    lat_mrf = float(mrfData.getString(i,3));
    lon_mrf = float(mrfData.getString(i,4));
    int mrf_id = int(mrfData.getString(i,0));
      if(mrf_id != previd_mrf){
        if(mrfcoords.size() > 0){ //create constructor for kcoords
          Point_k mrf = new Point_k(lat_mrf,lon_mrf);
          //mrf.typeK = false;
          mrf.typeMRF = true;
          mrf_array.add(mrf);
        }
        //clear coords
        mrfcoords = new ArrayList<PVector>();
        //reset variable
        previd_mrf = mrf_id;
      }
      if(mrf_id == previd_mrf){
        float lat_mrfmatch = float(mrfData.getString(i,3)); //west
        float lon_mrfmatch = float(mrfData.getString(i,4));
        mrfcoords.add(new PVector(lat_mrfmatch, lon_mrfmatch));
      }
  }
  
  //make Lines if it's a LineString
  /*
  for(int i = 0; i<line_features.size(); i++){
    String type = line_features.getJSONObject(i).getString("type");
    String geometry = line_features.getJSONObject(i).getString("coordinates");
    println(geometry);
  }

        //make a new Line
        ArrayList<PVector> line_coords = new ArrayList<PVector>();
        //get coordinates and iterate through them
        JSONArray coordinates = geometry.getJSONArray("coordinates");
        for(int j = 0; j<coordinates.size(); j++){
          float lat = coordinates.getJSONArray(j).getFloat(1);
          float lon = coordinates.getJSONArray(j).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat,lon);
          line_coords.add(coordinate);
        }
        //create the Way with the coordinate PVectors
        Way way = new Way(line_coords);
        ways.add(way);
      }
      */
      
  println("Data Parsed");
}

void makeFakeHeatmap(){
  
  numXCells = int(width/cellWidth) + 1;
  numYCells = int(height/cellHeight) + 1;
  PopData = loadTable("data/mumbai_pop2011-attributes.csv", "header");
  
  heatmap = new Heatmap(numXCells, numYCells, cellWidth, cellHeight);
  float[][] randData = new float[numXCells][numYCells];
  float[][] popSquare = new float[numXCells][numYCells];
  
  for(int i = 0; i<numXCells; i++){
    for(int j = 0; j<numYCells; j++){
      //in each cell, load this color
      //randData[i][j] = random(200);
      //first, in each cell, load the color of the normalized population by area
      
      //value of the pop_km
    }
  }
  heatmap.scores = popSquare;
  heatmap.normalizeScores();

  heatmap.draw();
}


class Heatmap{
  int cellX, cellY;
  float cellW, cellH;
  float[][] scores;
  color worst, mid, best;
  PGraphics p;
 
  Heatmap(){}
  
  Heatmap(int _cellX, int _cellY, float _cellW, float _cellH){
    cellX = _cellX;
    cellY = _cellY;
    cellW = _cellW;
    cellH = _cellH;
    worst = color(200, 0, 0);
    mid = color(255, 255, 0);
    best = color(0, 200, 0);
    scores = new float[cellX][cellY];
    p = createGraphics(int(cellX*cellW), int(cellY*cellH));
    
  }
  
  void normalizeScores(){
    float min = 1000000;
    float max = 0;
    for(int i = 0; i<cellX; i++){
      for(int j = 0; j<cellY; j++){
        float val = scores[i][j];
        if (val < min) min = val;
        if (val > max) max = val;
      }
    }
    
    for(int i = 0; i<cellX; i++){
      for(int j = 0; j<cellY; j++){
        float val = scores[i][j];
        float newVal = map(val, min, max, 0, 100);
        scores[i][j] = newVal;
      }
    }
  }
  
  void draw(){
    p.beginDraw();
    p.clear();
    for(int i = 0; i<cellX; i++){
      for(int j = 0; j<cellY; j++){
        color col = color(0, 0, 0);
        float val = scores[i][j];
        if(val < 50) col = lerpColor(worst, mid, val/100);
        if(val == 50) col = mid;
        if(val > 50) col = lerpColor(mid, best, val/100-.5);
        p.fill(col);
        p.noStroke();
        p.rect(i*cellW, j*cellH, cellW, cellH);
      }
    }
    p.endDraw();
    
  }
  
}
