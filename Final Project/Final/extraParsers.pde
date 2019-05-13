void parseDataMumbai() {
  //loop through each of the feature sets in Mumbai
  for (int f=0; f<geometries.size(); f++) {
    featureCollection = geometries.getJSONObject(f);
    features = featureCollection.getJSONArray("features");
    for (int g = 0; g<features.size(); g++) {
      String type = features.getJSONObject(g).getJSONObject("geometry").getString("type");
      JSONObject geometry = features.getJSONObject(g).getJSONObject("geometry");
      JSONObject properties = features.getJSONObject(g).getJSONObject("properties");

      //query the polygons
      String dataFclass = properties.getString("fclass");
      String fclass = "";
      if (dataFclass!=null) fclass = dataFclass;
      else fclass = "";

      //make Ways if way
      if (type.equals("MultiLineString")) {
        ArrayList<PVector> coords = new ArrayList<PVector>();
        //get coordinates and iterate
        JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
        for (int j = 0; j < coordinates.size(); j++) {
          float lat = coordinates.getJSONArray(j).getFloat(1);
          float lon = coordinates.getJSONArray(j).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
        //create Way with coordinate PVectors
        Way way = new Way(coords);

        if (fclass.equals("motorway") || fclass.equals("trunk") || fclass.equals("secondary") || fclass.equals("residential") || fclass.equals("tertiary") || fclass.equals("motorway_link")) {
          way.Street = true;
        }
        if (fclass.equals("coastline")) {
          way.Coastline = true;
        }
        if (fclass.equals("rail")) {
          way.Rail = true;
        }
        if (fclass.equals("river")) {
          way.Waterway = true;
        }


        ways.add(way);

        //make pair-nodes to draw a random point on any segment in the list of segments
        if (way.Street == true) {
          //coordinates.size() is the size of each road array
          //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
          //singlePair is a pair of joined road nodes: [ [],[] ]
          //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
          //concatenate collectionOfPairs for all streets you loop through
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
        } //end if way Street == true
      }//end if type = MultiLineString

      //make Polygons if polygon
      if (type.equals("MultiPolygon")) {
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
        //create Polygon with coordinate PVectors
        Polygon poly = new Polygon(coords);

        if (fclass.equals("building")) {
          //println("found a building");
          poly.BuildingResidential = true;
          poly.makeShape();
        }
        polygons.add(poly);
      } //end if type = MultiPolygon
    } //end iterating through Features

    //parse Kabadiwala and MRF points
    parseKabadiwala();
    parseMRF();
  } //end iterate through Feature Sets
} //end ParseDataMumbai

void parseOSMNX() {
  //parse the JSON object
  JSONObject feature = features.getJSONObject(0);
  println("feature loaded");
  //get the lines within this road file
  for (int i = 0; i<features.size(); i++) {
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    println("type: ", type);
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    println("geometry: ", geometry);
    JSONObject properties = features.getJSONObject(i).getJSONObject("properties");
    println("properties: ", properties);

    //add just the simplified road network of Ways
    //street lines
    String dataStreet;
    try {
      dataStreet = properties.getString("highway");
    }
    catch (Exception e) {
      dataStreet = properties.getJSONArray("highway").getString(0); //if it's an array, just get the first one
    }
    String street = "";
    if (dataStreet!=null) street = dataStreet;
    else street = "";

    parseMRF();
    parseKabadiwala();

    //make Way if LineString
    if (type.equals("MultiLineString")) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates");
      println("coordinates are: ", coordinates);
      for (int j = 0; j<coordinates.size(); j++) {
        for (int c = 0; c<2; c++) {
          float lat = coordinates.getJSONArray(j).getJSONArray(c).getFloat(1); //need to fix and convert these to decimal
          float lon = coordinates.getJSONArray(j).getJSONArray(c).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
      }
      //create Way with coordinate PVectors
      Way way = new Way(coords);

      if (street.equals("unclassified") || street.equals("motorway") || street.equals("trunk") || street.equals("primary") || street.equals("secondary") || street.equals("residential") || street.equals("tertiary") || street.equals("motorway_link")) {
        way.Street = true;
      }

      ways.add(way);

      //make pair-nodes
      if (way.Street == true) {
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        for (int a = 0; a < coords.size()-1; a++) {
          ArrayList singlePair = new ArrayList<PVector>();
          firstElement = coords.get(a);
          secondElement = coords.get(a+1);
          singlePair.add(firstElement);
          singlePair.add(secondElement);
          collectionOfPairs.add(singlePair);
          collectionOfCollections.add(singlePair);
        } //end make singlePairs
      } //end if way Street == true
    } //end if type equals MultiLineString
  } //end iterating through Features

  //checking to see if this is correct structure
  println("Total segment pairs in this road file: "+collectionOfCollections.size());
} //end parseOSMNX function


////////////extra HH parse function//////////////////
/*

  float lat_hh_path, lon_hh_path; 
  Map<String,ArrayList<PVector>> hhpath_coords_map = new HashMap<String,ArrayList<PVector>>();
  Map<String,ArrayList<PVector>> hh_merged_map = new HashMap<String,ArrayList<PVector>>();
  ArrayList<Map<String,ArrayList<PVector>>> full_path = new ArrayList<Map<String,ArrayList<PVector>>>();
  ArrayList<Map<String,ArrayList<PVector>>> map3 = new ArrayList<Map<String,ArrayList<PVector>>>();
  ArrayList<String> keys_only = new ArrayList<String>();
  
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
        /* println("FULL PATH COORD PAIR IS",coord_pair);
        //hold the paths for mapping
        Way way = new Way(coord_pair);
        ways.add(way);          
        way.HH_paths = false;  
        */
      //}
      
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
  //}
  //println(hhpath_coords_map.size());
  //println(hhpath_coords_map);

  //loop through keys_only and add to new arraylist only if the IDs are unique
    //ArrayList<String> keys_unique = new ArrayList<String>();
    //println("test: ",keys_only);
    //for(int u = 0; u<keys_only.size(); u++){
      //println(keys_only.get(0));
      //println(keys_only.get(1));
      /*
      if(keys_only.get(u) != keys_only.get(u+1)){
        keys_unique.add(keys_only.get(u));
      }
   // }
    //println("unique keys: ",keys_unique.size());
//}
*/



////// mergedMap //////

 /*
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
          ArrayList<ArrayList<PVector>> value = mergedMap.get(id);
          ArrayList<PVector> inner = new ArrayList<PVector>();  
          inner.add(coord_pair.get(0));     
          inner.add(coord_pair.get(1));
          value.add(inner);
          mergedMap.put(id, value);
        }
        else{
          ArrayList<ArrayList<PVector>> outer = new ArrayList<ArrayList<PVector>>();
          ArrayList<PVector> inner = new ArrayList<PVector>();  
          inner.add(coord_pair.get(0));     
          inner.add(coord_pair.get(1));
          outer.add(inner); // add first list
          mergedMap.put(id,  outer);
        }   
    }
  }
}
*/
