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
  ArrayList<PVector> foodcoords = new ArrayList<PVector>();
  float lat_food = float(attributes.getString(1,13))*-1;
  float lon_food = float(attributes.getString(1,12));
  //println(lat_food,lon_food);
      
  for(int i = 0; i<attributes.getRowCount(); i++){
    int foodid = int(attributes.getString(i,0));
      if(foodid != previd){
        if(foodcoords.size() > 0){ //create constructor for foodcords
          FoodPOI food = new FoodPOI(lat_food,lon_food);
          foods.add(food);
        }
        //clear coords
        foodcoords = new ArrayList<PVector>();
        //reset variable
        previd = foodid;
      }
      if(foodid == previd){
        float lat_foodmatch = float(attributes.getString(i,13))*-1; //west
        float lon_foodmatch = float(attributes.getString(i,12));
        foodcoords.add(new PVector(lat_foodmatch, lon_foodmatch));
      }
      println(foodcoords);
  }
  
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
