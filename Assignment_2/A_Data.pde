JSONObject mit_central;
JSONArray features;
JSONObject mit_all;
Table attributes;

void loadData(){
  background = loadImage("data/mit_central.png");
  background.resize(width,height);
  
  mit_central = loadJSONObject("data/mit_central_osm.json");//get mit central area
  features = mit_central.getJSONArray("features");
  println("There are: ",features.size(), " features");
  
  //load CSV also
  attributes = loadTable("data/freefood_metadata_2_26_19_geocoded.csv","header");
  //nodes = loadTable("data/)
  
}

void parseData(){
  
  //parse CSV
  int previd = 0; 
  ArrayList<PVector> coords = newArrayList<PVector>();
  for(int i = 0; i<attributes.getRowCount(); i++){
    int foodid = int(attributes.getString(i,0));
      if(shapeid != previd){
        if(coords.size() > 0){
          POI poi = new new POI(coords);
          pois.add(poi);
        }
        coords = new ArrayList<PVector>();
        //reset variable
        previd = shapeid;
      }
      if(shapeid == previd){
        float lat = float(attributes.getString(i,13));
        float lon = float(attributes.getString(i,12));
        coords.add(new PVector(lat, lon));
      }
  }
  println(pois.size());
  
  //parse JSON
  for(int i = 0; i<features.size(); i++){
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    JSONObject properties = features.getJSONObject(i).getJSONObject("properties");
  
    String dataAmenity = properties.getJSONObject("tags").getString("amenity"); //get amenity tag
    String amenity = ""; //check for gaps
    if(dataAmenity!=null) amenity = dataAmenity;
    else amenity = ""; //clean amenity field
    
    if(type.equals("Point")){
      //create new point
      float lat = geometry.getJSONArray("coordinates").getFloat(1);
      float lon = geometry.getJSONArray("coordinates").getFloat(0);
      
      POI poi = new POI(lat,lon); //make new POI from constructor template
      poi.type = amenity; //give the guy an amenity
      if(amenity.equals("restaurant")) {
        poi.Restaurant = true;
      }
      pois.add(poi);
    }
    
    if(type.equals("Polygon")){
      //make new polygon
      ArrayList<PVector> coords = new ArrayList<PVector>(); //make individual polygons
      //get all points making up the polygon
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
      //iterate through those points
      for(int j = 0; j<coordinates.size(); j++){
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //create Polygon with coordinate PVectors
      Polygon poly = new Polygon(coords);
      //poly.type = amenity;
      if(amenity.equals("university")) {
        poly.University = true;
      }
      polygons.add(poly);
    }
      
}
}
