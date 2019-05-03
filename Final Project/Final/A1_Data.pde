Map<String, Set<ArrayList<PVector>>> mergedMap = new HashMap<String, Set<ArrayList<PVector>>>();


//loading JSONs
JSONObject example;
JSONArray features;
JSONArray geometries;
JSONObject bandra;
Table kData, mrfData;

JSONObject mumbai_geojson;
JSONObject speeds;
JSONObject os_mumbai;
JSONObject featureCollection;

JSONObject hh_paths;
JSONArray hh_paths_features;

JSONObject hh_points;
JSONArray hh_points_features;

JSONObject ward_bound;
JSONArray ward_bound_features;

//declare Arrays
ArrayList<ArrayList<PVector>> collectionOfCollections = new ArrayList<ArrayList<PVector>>(); //array of collection of road segments
ArrayList collectionOfPairs = new ArrayList<PVector>(); //array of road segments
ArrayList collection_kcoords = new ArrayList<PVector>(); //array of kabadiwalas
ArrayList all_fclasses = new ArrayList(); //array of feature classes

void loadHHtoKabadiwala(){
 //load the paths from HH to kabadiwala
 hh_paths = loadJSONObject("data/paths/hh_to_k_shortened_formatted.json");
 hh_paths_features = hh_paths.getJSONArray("features");
 println("getting hh_paths_features");
 
 hh_points = loadJSONObject("data/points/hh_to_k_pts_shortened_formatted.json");
 hh_points_features = hh_points.getJSONArray("features");
 println("getting hh_points_features");
}

void loadWardBoundaries(){
  ward_bound = loadJSONObject("data/base/mumbai_admin_wards_json_formatted.json");
  ward_bound_features = ward_bound.getJSONArray("features");
  println("getting ward features");
}

void loadDataBandra() {
  //load and resize background image map if you want to include one
  //background = loadImage("data/ImageMap.png");
  //background.resize(width, height);

  bandra = loadJSONObject("data/base/bandra.json");
  features = bandra.getJSONArray("features");
  println("getting features");
}

void loadDataOSMNX() { //OSMNX file of Mumbai simplified roads
  os_mumbai = loadJSONObject("data/base/osmnx_mumbai.geojson");
  features = os_mumbai.getJSONArray("features");
}

void loadDataSpeeds() { //most granular roads data with speeds in metadata
  speeds = loadJSONObject("data/base/mumbai_speeds.geojson");
  features = speeds.getJSONArray("features");
  println("SPEED DATA loaded");
}

void loadDataMumbai() { //load OSM file of Mumbai without simplified roads
  mumbai_geojson = loadJSONObject("data/base/mumbai_all.geojson");
  geometries = mumbai_geojson.getJSONArray("geometries");
}

void load_k_mrf() { //load kabadiwala and MRF points
  kData = loadTable("data/points/k_short_snapped.csv", "header");
  mrfData = loadTable("data/points/mrf_formatted.csv", "header");
  println("data loaded!");
}

///////////////////////////////////////////////////////
void parseHHtoKabadiwala(){
  println("calling hh path to kabadiwala parse");
  float lat_hh_path, lon_hh_path; 
  String hhpaths_k_id;
  String hhpaths_pt_id;
  String hhpaths_k_previd = "previous";
  Map<String,ArrayList<PVector>> hhpath_coords_map = new HashMap<String,ArrayList<PVector>>();
  Map<String,ArrayList<PVector>> hh_merged_map = new HashMap<String,ArrayList<PVector>>();
  ArrayList<Map<String,ArrayList<PVector>>> full_path = new ArrayList<Map<String,ArrayList<PVector>>>();
  ArrayList<Map<String,ArrayList<PVector>>> map3 = new ArrayList<Map<String,ArrayList<PVector>>>();
  ArrayList<String> keys_only = new ArrayList<String>();
  
  
  /////////////////////  /////////////////////  /////////////////////   NINA CODE  /////////////////////  /////////////////////  /////////////////////  /////////////////////
  
  //mergedMap consists of key//values array of all the paths. You can query it. 
  
  HashSet<String> ids = new HashSet<String>();
  //previously had MERGEDMAP here, now made it global
  //looping through each of the features (coordinate pairs)
  int lengthReal = hh_paths_features.size();
  
  for(int i = 0; i<hh_paths_features.size(); i++){
    hhpaths_k_id = hh_paths_features.getJSONObject(i).getJSONObject("attributes").getString("k_id");
    hhpaths_pt_id = hh_paths_features.getJSONObject(i).getJSONObject("attributes").getString("pt_id");
    JSONArray hh_path_jsonarray = hh_paths_features.getJSONObject(i).getJSONObject("geometry").getJSONArray("paths");
    String id = hhpaths_k_id+"-"+hhpaths_pt_id; //i.e. 1-1
    ids.add(id);
    
    ArrayList<ArrayList<PVector>> coordinatePairs = new ArrayList<ArrayList<PVector>>();
       for (int j = 0; j<hh_path_jsonarray.size(); j++){
          ArrayList<PVector> coord_pair = new ArrayList<PVector>();
          //inside each path are 2 coordinate pairs
          for(int k = 0; k<2; k++){
          float path_lat = hh_path_jsonarray.getJSONArray(j).getJSONArray(k).getFloat(1);
          float path_lon = hh_path_jsonarray.getJSONArray(j).getJSONArray(k).getFloat(0);
          PVector path_coordinate = new PVector(path_lat,path_lon);
          //add those coordinate pairs to the coord_pair array
          coord_pair.add(path_coordinate);
          }
          
        coordinatePairs.add(coord_pair);
                
        if(mergedMap.keySet().contains(id)){
          Set<ArrayList<PVector>> value = mergedMap.get(id);
          ArrayList<PVector> inner = new ArrayList<PVector>();  
          inner.add(coord_pair.get(0));     
          inner.add(coord_pair.get(1));
          value.add(inner);
        }
        else{
          Set<ArrayList<PVector>> outer = new HashSet<ArrayList<PVector>>();
          ArrayList<PVector> inner = new ArrayList<PVector>();  
          
          inner.add(coord_pair.get(0));     
          inner.add(coord_pair.get(1));
          outer.add(inner); // add first list
          
          mergedMap.put(id,  outer);
        }   
    }
  }
  
  for(String s : mergedMap.keySet()){
    println(s + "//" + mergedMap.get(s));
  }
  /////////////////////  /////////////////////  /////////////////////  END  NINA CODE  /////////////////////  /////////////////////  /////////////////////  /////////////////////
  
  //looping through each of the features (coordinate pairs)
  for(int i = 0; i<hh_paths_features.size(); i++){
    hhpaths_k_id = hh_paths_features.getJSONObject(i).getJSONObject("attributes").getString("k_id");
    hhpaths_pt_id = hh_paths_features.getJSONObject(i).getJSONObject("attributes").getString("pt_id");
    JSONArray hh_path_jsonarray = hh_paths_features.getJSONObject(i).getJSONObject("geometry").getJSONArray("paths");
    String k_hh_path_key = hhpaths_k_id+"-"+hhpaths_pt_id; //i.e. 1-1
    
    ////////SEE INSTRUCTIONS BELOW for what I'd like to build. I need a list of k_id's and pt_id's that I can query to draw the 
    ////////line path between them and have the agent use that path to travel. After the agent has done a roundtrip on that path,
    ////////I will make another path and a new agent. I do this 10 times for each kabadiwala, representing 10 trips. There are
    ////////162 kabadiwalas, and 10 trips each, so 1620 paths. 
    //////// k_id is the kabadiwala
    //////// pt_id is the endpoint of the line
    //////// each part of the JSON has a k_id and pt_id associated with it. I need to assemble the lines by grouping the ones 
    //////// with the same k_id and pt_id, i.e. "1-1" for kabadiwala 1, path 1, or "23-10" for kabadiwala 23, path 10. 
    //////// Need to see if the way I build the lines will put each segment coordinate pair in the right order so that there's a 
    //////// clear START and END part of the line. This is how I'm building each path and it's a central part of my visualization. 
    
    // 1. group the JSON by k_hh_path_key. Every time the k_id = 1 and pt_id = 1, group the lat/lon coordinate pairs in a single group. 
    
      //if 1-1 is the same as 1-1
      //make an empty array of [ [ [,],[,] ] , [ [,],[,] ] ]
      //fill the lat/lon in PVector [x,y]
      //fill the coord_pair [ [x,y],[x,y] ] 
      //tag with unique ID
      //fill the full path [ [ [x,y],[x,y] ] , [ [x,y],[x,y] ] ]
      
      //provide a kabadiwala to parse and a path of the kabadiwala ("1-1")
      //parser goes into the file and parses that number of segments
      //segments are placed in an array that is displayed
      //each segment group for a given ID is drawn and path becomes that agent's path
             
        //make 2-point segments that need to be concatenated into a larger array
        //[ [x,y],[x,y] ]        
        for (int j = 0; j<hh_path_jsonarray.size(); j++){
          ArrayList<PVector> coord_pair = new ArrayList<PVector>();
          //inside each path are 2 coordinate pairs
          for(int k = 0; k<2; k++){
          float path_lat = hh_path_jsonarray.getJSONArray(j).getJSONArray(k).getFloat(1);
          float path_lon = hh_path_jsonarray.getJSONArray(j).getJSONArray(k).getFloat(0);
          PVector path_coordinate = new PVector(path_lat,path_lon);
          //add those coordinate pairs to the coord_pair array
          coord_pair.add(path_coordinate);
          }
          
        //now add each of these separate paths to a new array
        hhpath_coords_map.put(k_hh_path_key,coord_pair);
        
        //// END WORKING CODE ////
        
        
        //concatenate each of the hashmap pairs into a full path
        //something wrong here with the adding...
        full_path.add(hhpath_coords_map);
       /*
        //hold the paths for mapping
        Way way = new Way(coord_pair);
        ways.add(way);          
        way.HH_paths = false;  
        */
      }
      
      //println(full_path);
      
      
      /// trying to group by key for full_paths ///
      
      //attempt 1
      /*
       for (Map.Entry<String, ArrayList<PVector>> e : full_path.entrySet()){ 
          println("e is:",e);
          println("e key type: ",e.getKey());
          println("e value type: ",e.getValue());
          //map3.putAll(e.getKey(),e.getValue());
          map3.merge(e.getKey(), e.getValue()), String::concat);
        }
        */
        
      //attempt 2
      //loop through full_path and concatenate those which have the same key
      //String keyToSearch = k_hh_path_key;
      /*
        for (Map<String, ArrayList<PVector>> map : full_path) {
          for(String key : map.keySet()){
            //println(map.get(key));
            //map3.merge(String.valueOf(key), map.get(key), ArrayList<PVector>::concat);
          }

          for (String key : map.keySet()) {
            if(keyToSearch.equals(key)) {
              //map3.merge(key, map.get(key), ArrayList<PVector>::concat);
            }
              //ArrayList<PVector> currentPath = map.get(keyToSearch);
              //newValue = currentPath + map.keySet(key)
              //println("Found : " + key + " / value : " + map.get(key));
            }
          }
          */
          
      ////attempt 3
      //Map<String, ArrayList<PVector>> full_path_treemap = new TreeMap<String,ArrayList<PVector>>(full_path);
      //println(full_path_treemap);
      
      //attempt 4
      
      //Let's make a set of the keys that we want 
      //-- sometimes it helps to make a new helper structure like this later in the code so you know where you mad it
      
      //Set<String> keystoMerge = new HashSet<String>();

      
      //for(Map<String, ArrayList<PVector>> Map : full_path){
      //  // For each hashmap, iterate over it
      //  for (Map.Entry<String, ArrayList<PVector>> entry : Map.entrySet())
      //  {
      //     // Do something with your entrySet, for example get the key.
      //     String key1 = entry.getKey();
      //     ArrayList<PVector> value1 = entry.getValue();
      //     if(mergedMap.keySet().contains(key1)){
      //         Set<ArrayList<PVector>> valueOld = mergedMap.get(key1);
      //         valueOld.add(value1);
      //         Set<ArrayList<PVector>> valueNew = valueOld;
      //         mergedMap.put(key1, valueNew);
      //     }
      //     else{
      //       Set<ArrayList<PVector>> valueNew = new HashSet<ArrayList<PVector>>();
      //       valueNew.add(value1);
      //       mergedMap.put(key1, valueNew);
      //     }
      //  }
      //}
      
      //for(String keyString : mergedMap.keySet()){
      //  println(keyString + mergedMap.get(keyString));
      //}
     
      
      
    //Way way = new Way(hh_path_array);
  }
  //println(hhpath_coords_map.size());
  //println(hhpath_coords_map);

  //loop through keys_only and add to new arraylist only if the IDs are unique
    ArrayList<String> keys_unique = new ArrayList<String>();
    //println("test: ",keys_only);
    for(int u = 0; u<keys_only.size(); u++){
      //println(keys_only.get(0));
      //println(keys_only.get(1));
      /*
      if(keys_only.get(u) != keys_only.get(u+1)){
        keys_unique.add(keys_only.get(u));
      }
      */
    }
    //println("unique keys: ",keys_unique.size());
    

}

///////////////////////// parsing the endpoints (each pt_id) to draw separately ////////////////////
void parseHHPoints(){
  println("calling hh points parse");
  float lat_hh, lon_hh; 
  String hhpoints_k_id;
  String hhpoints_pt_id;
  
  for(int i = 0; i<hh_points_features.size(); i++){
    hhpoints_k_id = hh_points_features.getJSONObject(i).getJSONObject("attributes").getString("k_id");
    hhpoints_pt_id = hh_points_features.getJSONObject(i).getJSONObject("attributes").getString("hh_id");
    lat_hh = hh_points_features.getJSONObject(i).getJSONObject("geometry").getFloat("y");
    lon_hh = hh_points_features.getJSONObject(i).getJSONObject("geometry").getFloat("x");
    
    //make a HashMap of endpoints
    //give each endpoint a unique ID
    String k_hh_key = hhpoints_k_id+"-"+hhpoints_pt_id;
    
    //give each endpoint an coordinates array
    PVector hh_endpoint = new PVector();
    hh_endpoint.add(lat_hh,lon_hh);
    
    //each endpoint has a k_id, point_id, and coordinate
    hh_endpoint_map.put(k_hh_key,hh_endpoint);
   
   ////ISSUE IS HERE///
   //if you provide a k_hh_key, use hh_endpoint_map.get to get the location for that k_hh_key
   POI_hh h = new POI_hh(hh_endpoint);
   //poi_hh_array.add(h); //will not add to array and display as a point
   //println(k_hh_key+" id has location: ",hh_coords_map.get(k_hh_key));
  }        
  //println(hh_endpoint_map);
}


void parseWardBoundaries(){
  println("calling parseWardBoundaries()");
  for (int i = 0; i<ward_bound_features.size(); i++){
    String ward_name = ward_bound_features.getJSONObject(i).getJSONObject("attributes").getString("Name");
    int ward_area = ward_bound_features.getJSONObject(i).getJSONObject("attributes").getInt("area");
    println("Ward "+ward_name + " Area: "+ward_area + " km");
    for(int j = 0; j<ward_bound_features.size(); j++){
      JSONObject geometry = ward_bound_features.getJSONObject(j).getJSONObject("geometry");
    
      //treat rings like lines
      ArrayList<PVector> coords = new ArrayList<PVector>();
        //get coordinates and iterate through them
        JSONArray coordinates = geometry.getJSONArray("rings").getJSONArray(0);
        for (int k = 0; k < coordinates.size(); k++) {
          float lat = coordinates.getJSONArray(k).getFloat(1);
          float lon = coordinates.getJSONArray(k).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
        
        Way way = new Way(coords);
        ways.add(way);   
        way.WardBounds = true;
    }

  }
    println("total ways added: ",ways.size());
}

void parseOSMElements(){} //adds buildings, land use, railways, waterways to map

void parseData() {
  println("Calling parseData()");
  //parse the JSON object
  //sort 3 types into classes to draw: properties, geometry, type
  for (int i = 0; i<features.size(); i++) {
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    JSONObject properties = features.getJSONObject(i).getJSONObject("properties");

    //add various layers
    //building polygons
    String dataBuilding = properties.getJSONObject("tags").getString("building");
    String building = ""; //check for gaps
    if (dataBuilding!=null) building = dataBuilding;
    else building = ""; //clean amenity field

    //coastline linestrings
    String dataNatural = properties.getJSONObject("tags").getString("natural");
    String natural = "";
    if (dataNatural!=null) natural = dataNatural;
    else natural ="";

    //rail linestrings
    String dataRail = properties.getJSONObject("tags").getString("railway");
    String rail = "";
    if (dataRail!=null) rail = dataRail;
    else rail ="";

    //waterway linestrings
    String dataWaterway = properties.getJSONObject("tags").getString("waterway");
    String waterway = "";
    if (dataWaterway!=null) waterway = dataWaterway;
    else waterway ="";

    //street linestrings
    String dataStreet = properties.getJSONObject("tags").getString("highway");
    String street = "";
    if (dataStreet!=null) street = dataStreet;
    else street = "";

    /*
    //make POIs if point
    if (type.equals("Point")) {
      //create new POI
      float lat = geometry.getJSONArray("coordinates").getFloat(1);
      float lon = geometry.getJSONArray("coordinates").getFloat(0);
      POI poi = new POI(lat, lon,0);
      pois.add(poi);
    }
    */


    //make Polygons if polygon
    if (type.equals("Polygon")) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
      for (int j = 0; j < coordinates.size(); j++) {
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //make PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //create Polygon with coordinate PVectors
      Polygon poly = new Polygon(coords);

      if (building.equals("residential") || building.equals("apartments") || building.equals ("yes")) {
        poly.BuildingResidential = true;
        poly.makeShape();
      }
      polygons.add(poly);
    }

    //make Way if LineString
    if (type.equals("LineString")) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates");
      for (int j = 0; j<coordinates.size(); j++) {
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //make PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //create Way with coordinate PVectors
      Way way = new Way(coords);

      if (street.equals("unclassified") || street.equals("motorway") || street.equals("trunk") || street.equals("primary") || street.equals("secondary") || street.equals("residential") || street.equals("tertiary") || street.equals("motorway_link")) {
        way.Street = true;
      }
      if (natural.equals("coastline")) {
        way.Coastline = true;
      }
      if (rail.equals("rail")) {
        way.Rail = true;
      }
      if (waterway.equals("river")) {
        way.Waterway = true;
      }

      ways.add(way);
      
      //println("ways added: ", ways.size()); //<-- this seems low
      //println("coords added: ", coords.size()); //<-- this seems low
      

      //make pair-nodes
      if (way.Street == true) {
        //coordinates.size() is the size of each road array
        //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
        //singlePair is a pair of joined road nodes: [ [],[] ]
        //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
        //concatenate collectionOfPairs for all streets you loop through
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        for (int a = 0; a < coords.size()-1; a++) { //for each element in the single road array:
          ArrayList singlePair = new ArrayList<PVector>();
          firstElement = coords.get(a);
          secondElement = coords.get(a+1);
          singlePair.add(firstElement);  //add 1 and 2 to singlePair
          singlePair.add(secondElement);
          collectionOfPairs.add(singlePair); //add singlePair to the collection for that road
          collectionOfCollections.add(singlePair);
        } //end make singlePairs
      } //end if way Street == true
    } //end if type equals LineString
  } //end parseData's 3-way sorting

  parseMRF(); //read in MRF CSV
  parseKabadiwala(); //read in Kabadiwala CSV

  println("Total segment pairs in this road file: "+collectionOfCollections.size());
  println("Completed Parsing");
} //end parseData function



//////////////////////////////////////////////////// parse Roads
void parseSpeeds() {
  for (int t = 26000; t < features.size(); t++) { //framerate seriously affected around 26000 and out of memory at 25000
    JSONObject geometry = features.getJSONObject(t);
    //println("geometry looks like",geometry);
    for (int u = 0; u < geometry.size(); u++) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      JSONArray coordinates = geometry.getJSONObject("geometry").getJSONArray("coordinates").getJSONArray(0);
      //println("coordinates are: ",coordinates);

      for (int v = 0; v < coordinates.size(); v++) {
        float lat = coordinates.getJSONArray(v).getFloat(1);
        float lon = coordinates.getJSONArray(v).getFloat(0);

        //make PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //create Way with coordinate PVectors
      Way way = new Way(coords);

      way.Street = true;

      ways.add(way);
      //println("ways added: ", ways.size()); //<-- this seems low
      //println("coords added: ", coords.size()); //<-- this seems low
      
      if (way.Street==true) {
        //make pair-nodes
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        //for each element in the single road array:
        for (int a = 0; a < coords.size()-1; a++) {
          ArrayList singlePair = new ArrayList<PVector>();
          firstElement = coords.get(a);
          secondElement = coords.get(a+1);
          //add 1 and 2 to singlePair
          singlePair.add(firstElement);
          singlePair.add(secondElement);
          //add singlePair to the collection for that road
          collectionOfPairs.add(singlePair);
          collectionOfCollections.add(singlePair);
        } //end make singlePairs
      } //end if statement
    }
  }
  parseMRF(); //read in MRF CSV
  parseKabadiwala(); //read in Kabadiwala CSV
  println("Total segment pairs in this road file: "+collectionOfCollections.size());
  //println("CC: ", collectionOfCollections);
  println("ENDING CALLING PARSE DATA");
}




////////////////////////// parse Kabadiwalas and MRFs //////////////////////////////////////////////////////////////////////////////////

void parseKabadiwala() {
  println("PARSE KABADIWALA");
  //parse CSV for k
  int previd_k = 0; 
  float lat_k, lon_k;
  String ward; 
  ArrayList<PVector> kcoords = new ArrayList<PVector>();

  for (int m = 0; m<kData.getRowCount(); m++) {
    ward = kData.getString(m, 1);
    lat_k = float(kData.getString(m, 2));
    lon_k = float(kData.getString(m, 3));

    //only for Bandra kabadiwalas, can add the others once the GeoJSON full merge on all street networks is operational
    if (ward.equals("HW")|| ward.equals("N") || ward.equals("RN")){ 
      int k_id = int(kData.getString(m, 0));
      if (k_id != previd_k) {
        if (kcoords.size() > 0) { //create constructor for kcoords
          Point_k k = new Point_k(lat_k, lon_k);
          k.typeK = true;
          k_array.add(k);
        }
        //clear coords
        kcoords = new ArrayList<PVector>();
        //reset variable
        previd_k = k_id;
      }
      if (k_id == previd_k) {
        float lat_kmatch = float(kData.getString(m, 2)); //west
        float lon_kmatch = float(kData.getString(m, 3));
        PVector temp = new PVector(lat_kmatch, lon_kmatch);
        kcoords.add(temp);
        collection_kcoords.add(temp);
      }
    }
  }
}

void parseMRF() {
  //parse CSV for MRF
  int previd_mrf = 0; 
  ArrayList<PVector> mrfcoords = new ArrayList<PVector>();
  float lat_mrf, lon_mrf;
  for (int n = 0; n<mrfData.getRowCount(); n++) {
    lat_mrf = float(mrfData.getString(n, 3));
    lon_mrf = float(mrfData.getString(n, 4));
    int mrf_id = int(mrfData.getString(n, 0));
    if (mrf_id != previd_mrf) {
      if (mrfcoords.size() > 0) { //create constructor for kcoords
        Point_k mrf = new Point_k(lat_mrf, lon_mrf);
        //mrf.typeK = false;
        mrf.typeMRF = true;
        mrf_array.add(mrf);
      }
      //clear coords
      mrfcoords = new ArrayList<PVector>();
      //reset variable
      previd_mrf = mrf_id;
    }
    if (mrf_id == previd_mrf) {
      float lat_mrfmatch = float(mrfData.getString(n, 3)); //west
      float lon_mrfmatch = float(mrfData.getString(n, 4));
      mrfcoords.add(new PVector(lat_mrfmatch, lon_mrfmatch));
    }
  }
}

void drawGISObjects() {

  //draw all Polygons
  /*
  for(int i = 0; i<polygons.size(); i++){
   polygons.get(i).draw();
   }
   */

  
  //draw all POIs
   for(int i = 0; i<pois.size(); i++){
   pois.get(i).draw();
   }
   

  //draw all Ways
  for (int i = 0; i<ways.size(); i++) {
    ways.get(i).draw();
  }
}
