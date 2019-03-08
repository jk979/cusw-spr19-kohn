JSONObject example;
JSONArray features;
JSONObject bandra;

void loadData(){
  //load and resize background Bandra image
  //background = loadImage("data/Bandra.png");
  //background.resize(width, height);
  
  //load and resize Bandra JSON object with all the features in it
  bandra = loadJSONObject("data/bandra.json");
  features = bandra.getJSONArray("features");
  
  println("there are: ", features.size(), "features.");
  println("data loaded!");
}

void parseData(){
  //parse the JSON object
  JSONObject feature = features.getJSONObject(0);
  println("feature loaded");
  //sort 3 types into classes to draw: properties, geometry, type
  for(int i = 0; i<features.size(); i++){
  String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
  JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
  JSONObject properties = features.getJSONObject(i).getJSONObject("properties");
  
  //make POIs if point
  if(type.equals("Point")){
    //create new POI
    float lat = geometry.getJSONArray("coordinates").getFloat(1);
    float lon = geometry.getJSONArray("coordinates").getFloat(0);
    POI poi = new POI(lat,lon);
    pois.add(poi);
  }
  
  //make Polygons if polygon
  if(type.equals("Polygon")){
    ArrayList<PVector> coords = new ArrayList<PVector>();
    //get coordinates and iterate through them
    JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
    for(int j = 0; j < coordinates.size(); j++){
      float lat = coordinates.getJSONArray(j).getFloat(1);
      float lon = coordinates.getJSONArray(j).getFloat(0);
      //make PVector and add it
      PVector coordinate = new PVector(lat, lon);
      coords.add(coordinate);
    }
    //create Polygon with coordinate PVectors
    Polygon poly = new Polygon(coords);
    polygons.add(poly);
  }
  
  //make Way if LineString
  if(type.equals("LineString")){
    ArrayList<PVector> coords = new ArrayList<PVector>();
    //get coordinates and iterate through them
    JSONArray coordinates = geometry.getJSONArray("coordinates");
    for(int j = 0; j<coordinates.size();j++){
      float lat = coordinates.getJSONArray(j).getFloat(1);
      float lon = coordinates.getJSONArray(j).getFloat(0);
      //make PVector and add it
      PVector coordinate = new PVector(lat, lon);
      coords.add(coordinate);
    }
    //create Way with coordinate PVectors
    Way way = new Way(coords);
    ways.add(way);
  }
  
  //println("data parsed!");
  
}
}

void drawGISObjects(){
  //draw all Ways
  for(int i = 0; i<ways.size(); i++){
    ways.get(i).draw();
  }
  
  /*
  //draw all Polygons
  for(int i = 0; i<polygons.size(); i++){
    polygons.get(i).draw();
  }
  
  //draw all POIs
  for(int i = 0; i<pois.size(); i++){
    pois.get(i).draw();
  }
  */
  
}
