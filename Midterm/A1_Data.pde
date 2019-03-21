//loading JSONs
JSONObject example;
JSONArray features;
JSONArray geometries;
JSONObject bandra;
Table kData, mrfData;
JSONObject mumbai_geojson;
JSONObject featureCollection;

//drawing paths
PVector randomKabadiwala = new PVector();
PVector randomSource = new PVector();
PVector kabadiwala = new PVector();
PVector source = new PVector();
PVector bundle = new PVector();
int euclideanAgentBundle;
int euclideanOriginBundle;

//costs and quantities (can change these dynamically)
//paper
int kabadiwala_pickup_cost_paper;
int paperKBuy = 10;
int paperQuantity = 1500;
int kabadiwala_offload_cost_paper;
int paperKSell = 12;

//plastic
int kabadiwala_pickup_cost_plastic;
int plasticKBuy = 12; 
int plasticQuantity = 120; 
int kabadiwala_offload_cost_plastic;
int plasticKSell = 20;

//glass
int kabadiwala_pickup_cost_glass;
int glassKBuy = 1; 
int glassQuantity = 60; 
int kabadiwala_offload_cost_glass;
int glassKSell = 4;

//metal
int kabadiwala_pickup_cost_metal;
int metalKBuy = 80; 
int metalQuantity = 10; 
int kabadiwala_offload_cost_metal;
int metalKSell = 100;

//distance calculation
float HavD;
int roundtripKM;

//for pair-nodes
import java.util.HashSet;

ArrayList<ArrayList<PVector>> collectionOfCollections = new ArrayList<ArrayList<PVector>>();
ArrayList collectionOfPairs = new ArrayList<PVector>();
ArrayList collection_kcoords = new ArrayList<PVector>();
ArrayList all_fclasses = new ArrayList();


void loadData() {
  //load and resize background Bandra image
  //background = loadImage("data/Bandra.png");
  //background.resize(width, height);

  //load and resize Bandra JSON object with all the features in it
  bandra = loadJSONObject("data/bandra.json");
  features = bandra.getJSONArray("features");

  //mumbai_geojson = loadJSONObject("data/mumbai_all.geojson");
  //geometries = mumbai_geojson.getJSONArray("geometries");

  //load kabadiwala points
  kData = loadTable("data/k_short.csv", "header");
  //load MRF points
  mrfData = loadTable("data/mrf_formatted.csv", "header");

  //println("there are: ", features.size(), "features.");
  println("data loaded!");
}


void parseDataMumbai() {
  //loop through each of the feature sets in Mumbai
  for (int f=0; f<geometries.size(); f++) {
    //println("a geometry"+i); //each geometries is a JSONArray, there are 17
    featureCollection = geometries.getJSONObject(f);
    features = featureCollection.getJSONArray("features");
    //println(features.getJSONObject(0));
    for (int g = 0; g<features.size(); g++) {
      String type = features.getJSONObject(g).getJSONObject("geometry").getString("type");
      JSONObject geometry = features.getJSONObject(g).getJSONObject("geometry");
      JSONObject properties = features.getJSONObject(g).getJSONObject("properties");

      //query the polygons
      String dataFclass = properties.getString("fclass");
      String fclass = "";
      if (dataFclass!=null) fclass = dataFclass;
      else fclass = "";
      //println(polygon);

      //fclass building has types 


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
        
      //make pair-nodes
      if (way.Street == true) {
        //println("CC is now"+collectionOfCollections.size());
        //coordinates.size() is the size of each road array
        //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
        //singlePair is a pair of joined road nodes: [ [],[] ]
        //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
        //concatenate collectionOfPairs for all streets you loop through
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        //for each element in the single road array:
        //println("size of this block is " + coords.size());
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
        
      }

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
      }
    }
    parseKabadiwala();
    parseMRF();
  }
}

void parseData() {
  //parse the JSON object
  JSONObject feature = features.getJSONObject(0);
  println("feature loaded");
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

    //coastline linestring
    String dataNatural = properties.getJSONObject("tags").getString("natural");
    String natural = "";
    if (dataNatural!=null) natural = dataNatural;
    else natural ="";

    //rail linestring
    String dataRail = properties.getJSONObject("tags").getString("railway");
    String rail = "";
    if (dataRail!=null) rail = dataRail;
    else rail ="";

    //waterway linestring
    String dataWaterway = properties.getJSONObject("tags").getString("waterway");
    String waterway = "";
    if (dataWaterway!=null) waterway = dataWaterway;
    else waterway ="";

    //street polygons
    String dataStreet = properties.getJSONObject("tags").getString("highway");
    String street = "";
    if (dataStreet!=null) street = dataStreet;
    else street = "";

    //make POIs if point
    if (type.equals("Point")) {
      //create new POI
      float lat = geometry.getJSONArray("coordinates").getFloat(1);
      float lon = geometry.getJSONArray("coordinates").getFloat(0);
      POI poi = new POI(lat, lon);
      pois.add(poi);
    }
    
    parseMRF();
    parseKabadiwala();

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

      if (street.equals("unclassified") || street.equals("motorway") || street.equals("trunk") || street.equals("secondary") || street.equals("residential") || street.equals("tertiary") || street.equals("motorway_link")) {
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
      
      //make pair-nodes
      if (way.Street == true) {
        //println("CC is now"+collectionOfCollections.size());
        //coordinates.size() is the size of each road array
        //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
        //singlePair is a pair of joined road nodes: [ [],[] ]
        //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
        //concatenate collectionOfPairs for all streets you loop through
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        //for each element in the single road array:
        //println("size of this block is " + coords.size());
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
    } //end if type equals LineString
  } //end parseData's 3-way sorting

  //checking to see if this is correct structure
  println("Total segment pairs in this road file: "+collectionOfCollections.size());
} //end parseData function

void parseKabadiwala() {
  //parse CSV for k
  int previd_k = 0; 
  ArrayList<PVector> kcoords = new ArrayList<PVector>();
  float lat_k, lon_k;
  String ward; 
  for (int m = 0; m<kData.getRowCount(); m++) {
    ward = kData.getString(m, 1);
    lat_k = float(kData.getString(m, 2));
    lon_k = float(kData.getString(m, 3));

    //only for Bandra kabadiwalas, can add the others once the GeoJSON full merge on all street networks is operational
    if (ward.equals("HW")){ //|| ward.equals("N") || ward.equals("RN")){ 
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

//activate all kabadiwalas at once
void chooseAllKabadiwalas(){
 for(int q = 0; q<collection_kcoords.size()-1; q++){
  //get the index of each row
  int index = q;
  kabadiwala = (PVector)collection_kcoords.get(index);
  kabadiwala = map.getScreenLocation(kabadiwala);
  println("choosing all kabadiwalas");
 }
}

//build all sources at once
void chooseAllSources(){
  //get same number of sources as kabadiwalas
  for(int r = 0; r<collection_kcoords.size()-1; r++){
    int index = r; 
  //choose random sources within 3km network distance of these kabadiwala points
  
  }
}


/*
  Only set it if the Haversine from the random souce  is <= 2000 
*/
void chooseRandomKabadiwala() {
  boolean foundPoint = false;
  //chooses from big list of 199 kabadiwalas. May not show up on the small Bandra map for every run. 
  println("Random kabadiwala chosen from: "+collection_kcoords.size()); //kcoords is global
  int randomKIndex = parseInt(random(0, collection_kcoords.size()));
  println("the random KIndex is "+randomKIndex);
  //get kabadiwala coordinates for that index
  //println(collection_kcoords);
  println("type is"+collection_kcoords.getClass());

  while(!foundPoint){
    randomKIndex = parseInt(random(0, collection_kcoords.size()));
    HavD = (map.Haversine(map.getGeo(randomKabadiwala), map.getGeo(randomSource)));
    if(HavD <= 5000){
        println("Haversine is: ", (map.Haversine(map.getGeo(randomKabadiwala), map.getGeo(randomSource))));
        randomKabadiwala = (PVector)collection_kcoords.get(randomKIndex);
        randomKabadiwala = map.getScreenLocation(randomKabadiwala);
        foundPoint = true;
    }
  }
}

void displayKabadiwala() {
  stroke(color(255, 255, 255));
  noFill();
  polygon(randomKabadiwala.x, randomKabadiwala.y, 3, 4);
}

void displayAllKabadiwala(){
  fill(color(128,128,255));
  noStroke();
  for(int k = 0; k<collection_kcoords.size(); k++){
      polygon(kabadiwala.x, kabadiwala.y, 6, 4);
  }
}


//now determine a random Source point from collectionOfCollections
void chooseRandomSource() {
  //show size of the complete list of two-node segments
  println("Random source chosen from: "+collectionOfCollections.size());
  //get a random index from that list
  int randomIndex = parseInt(random(0, collectionOfCollections.size()));
  println("the random Index is "+ randomIndex); 
  //get the segment coordinates of that index
  ArrayList randomSegment = new ArrayList<PVector>();
  randomSegment = collectionOfCollections.get(randomIndex);
  println("the random Segment is "+randomSegment);
  //get the intermediate point between those two points
  println("the types of these points are " + randomSegment.get(0).getClass(), ", "+ randomSegment.get(1).getClass());
  PVector pt1 = (PVector)randomSegment.get(0);
  PVector pt2 = (PVector)randomSegment.get(1);

  //generate intermediate points
  PVector intermediates = map.intermediate(pt1, pt2, 0.5);
  randomSource = map.getScreenLocation(intermediates);
  bundle = map.getScreenLocation(intermediates);
}

void displaySource() {
  fill(color(255, 0, 0));
  noStroke();
  polygon(randomSource.x, randomSource.y, 6, 3);
}

void displayBundle() {
  stroke(color(255, 255, 0));
  noFill();
  ellipse(bundle.x, bundle.y, 13, 13);
}

void drawGISObjects() {

  //draw all Polygons
  /*
  for(int i = 0; i<polygons.size(); i++){
   polygons.get(i).draw();
   }
   */

  /*
  //draw all POIs
   for(int i = 0; i<pois.size(); i++){
   pois.get(i).draw();
   }
   */

  //draw all Ways
  for (int i = 0; i<ways.size(); i++) {
    ways.get(i).draw();
  }
}
