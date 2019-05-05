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

JSONObject railways;
JSONArray features_rail;

JSONObject buildings;
JSONArray features_buildings;

JSONObject hh_paths;
JSONArray hh_paths_features;

JSONObject hh_points;
JSONArray hh_points_features;

JSONObject ward_bound;
JSONArray ward_bound_features;

//declare Arrays and HashMaps
//household paths
Map<String, Set<ArrayList<PVector>>> mergedMap = new HashMap<String, Set<ArrayList<PVector>>>();

//legacy
ArrayList<ArrayList<PVector>> collectionOfCollections = new ArrayList<ArrayList<PVector>>(); //array of collection of road segments
ArrayList collectionOfPairs = new ArrayList<PVector>(); //array of road segments

//coordinates arrays for kabadiwala shops, MRFs, and wholesalers
ArrayList collection_kcoords = new ArrayList<PVector>(); //array of kabadiwalas
ArrayList collection_mrfcoords = new ArrayList<PVector>();
ArrayList collection_wcoords = new ArrayList<PVector>();

///////////////////////////////// LOAD FUNCTIONS ///////////////////////////////////

//load household paths
void loadHHtoKabadiwala(){
 //load the paths from HH to kabadiwala
 hh_paths = loadJSONObject("data/paths/hh_to_k_shortened_formatted.json");
 hh_paths_features = hh_paths.getJSONArray("features");
 println("getting hh_paths_features");
 hh_points = loadJSONObject("data/points/hh_to_k_pts_shortened_formatted.json");
 hh_points_features = hh_points.getJSONArray("features");
 println("getting hh_points_features");
}

//load ward boundaries
void loadWardBoundaries(){
  ward_bound = loadJSONObject("data/base/mumbai_admin_wards_json_formatted.json");
  ward_bound_features = ward_bound.getJSONArray("features");
  println("getting ward features");
}

//load map *bandra*
void loadDataBandra() {
  //load and resize background image map if you want to include one
  //background = loadImage("data/ImageMap.png");
  //background.resize(width, height);
  bandra = loadJSONObject("data/base/bandra.json");
  features = bandra.getJSONArray("features");
  println("getting features");
}

//load map *speeds* (huge file)
void loadDataSpeeds() { //most granular roads data with speeds in metadata
  speeds = loadJSONObject("data/base/mumbai_speeds.geojson");
  features = speeds.getJSONArray("features");
  println("SPEED DATA loaded");
}

void loadRailways() {
 railways = loadJSONObject("data/osm_geojson/o2g_railways.geojson");
 features_rail = railways.getJSONArray("features");
 println("loaded Rail data");
}

void loadBuildings() {
  buildings = loadJSONObject("data/osm_geojson/o2g_buildings_a.geojson");
  features_buildings = buildings.getJSONArray("features");
  println("loaded Building data");
}

/*
//load map *OSMNX*
void loadDataOSMNX() { //OSMNX file of Mumbai simplified roads
  os_mumbai = loadJSONObject("data/base/osmnx_mumbai.geojson");
  features = os_mumbai.getJSONArray("features");
}

//load map *OSM Mumbai without simplified roads*
void loadDataMumbai() { //load OSM file of Mumbai without simplified roads
  mumbai_geojson = loadJSONObject("data/base/mumbai_all.geojson");
  geometries = mumbai_geojson.getJSONArray("geometries");
}
*/

//load kabadiwala and MRF points CSV
void load_k_mrf() { 
  kData = loadTable("data/points/k_short_snapped.csv", "header");
  mrfData = loadTable("data/points/mrf_formatted.csv", "header");
  println("data loaded!");
}

/////////////////// PARSE FUNCTIONS //////////////////////////////

//parse household paths
void parseHHtoKabadiwala(){
  println("calling hh path to kabadiwala parse");
  String hhpaths_k_id;
  String hhpaths_pt_id;
    
  HashSet<String> ids = new HashSet<String>();
  
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
  //output: mergedMap which features all the lines inside it
  /*
  for(String s : mergedMap.keySet()){
    println(s + "//" + mergedMap.get(s));
  }
  */
}
  
//parse household endpoints to draw separately (or query their locations)
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
    
    //make a HashMap of endpoints  and give each endpoint a unique ID
    String k_hh_key = hhpoints_k_id+"-"+hhpoints_pt_id;
    
    //make coordinates for each ndpint
    PVector hh_endpoint = new PVector();
    hh_endpoint.add(lat_hh,lon_hh);
    
    //each endpoint has a unique ID and coordinate
    hh_endpoint_map.put(k_hh_key,hh_endpoint);
    }        
}

//parse Ward boundaries
void parseWardBoundaries(){
  println("calling parseWardBoundaries()");
  for (int i = 0; i<ward_bound_features.size(); i++){
    String ward_name = ward_bound_features.getJSONObject(i).getJSONObject("attributes").getString("Name");
    int ward_area = ward_bound_features.getJSONObject(i).getJSONObject("attributes").getInt("area");
    println("Ward "+ward_name + " Area: "+ward_area + " km");
    for(int j = 0; j<ward_bound_features.size(); j++){
      JSONObject geometry = ward_bound_features.getJSONObject(j).getJSONObject("geometry");
    
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
    //println("total ways added: ",ways.size());
}

void parseOSMElements(){} //adds buildings, land use, railways, waterways to map


void parseBuildings(){
  println("calling Bulidings");
  for(int i=0; i<features_buildings.size(); i++){
    String type = features_buildings.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features_buildings.getJSONObject(i).getJSONObject("geometry");
    
    if(type.equals("MultiPolygon")){
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0).getJSONArray(0);
      for (int j = 0; j < coordinates.size(); j++) {
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        
        //make PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //println("coords list is",coords);
      //create Polygon with coordinate PVectors
      Polygon poly = new Polygon(coords);
      poly.makeShape();
      polygons.add(poly);
      poly.BuildingResidential = true;

      
    }
  }
}

void parseRailways(){
  println("calling Railways");
  for(int i=0; i<features_rail.size(); i++){
    String type = features_rail.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features_rail.getJSONObject(i).getJSONObject("geometry");
    
    if (type.equals("MultiLineString")) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0); //list of all the coordinates in [ [[x,y],[x,y]] ] format
      for (int j = 0; j<coordinates.size(); j++) {
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //make PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
        }
      //create Way with coordinate PVectors
      Way way = new Way(coords);
      ways.add(way);
      way.Railway = true;

  }
  }
}

void parseWaterways(){
  
}

//parse buildings, railways, etc. for Bandra
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
      mrfcoords.add(new PVector(lat_mrfmatch,lon_mrfmatch));
      collection_mrfcoords.add(new PVector(lat_mrfmatch, lon_mrfmatch));
    }
  }
  println("mrf array size: ",mrf_array.size());
}

void drawGISObjects() {
  
  //draw all POIs
   for(int i = 0; i<pois.size(); i++){
   pois.get(i).draw();
   }
   

  //draw all Ways
  for (int i = 0; i<ways.size(); i++) {
    ways.get(i).draw();
  }
  
  //draw all Polygons
  for(int i = 0; i<polygons.size(); i++){
   polygons.get(i).draw();
   }
   
}
