//make Bundle
//each Bundle ID corresponds to the point it came from ("1_10")
//each material within the Bundle also corresponds to this ID ("1_10_a")

//draw all Kabadiwalas
//for each kabadiwala...
//draw all 10 shapefile paths
//draw bundles at all 10 areas
//send 1 agent on each path
//have the agent pick up and bundle
//have the agent drop off the bundle
//make bundle outline disappear

//for each MRF...
//run agent from MRF to MRF path 1
//run agent from MRF to MRF path 2
//run agent from MRF to MRF path 3
//picks up material from each kabadiwala on the way

//drawing paths
PVector kabadiwala_loc = new PVector();
PVector mrf_loc = new PVector();
PVector w_loc = new PVector();

PVector source = new PVector();
ArrayList<ArrayList<PVector>> bundles = new ArrayList<ArrayList<PVector>>();

//paths
PVector singleJourney = new PVector(); //K --> A
ArrayList roundTrip = new ArrayList<PVector>(); //K --> A --> K
ArrayList<ArrayList<PVector>> allTrips = new ArrayList<ArrayList<PVector>>(); //K <--> A, K <--> B, K <--> C

//bundles
PVector bundle = new PVector(); //one bundle
ArrayList multi_bundles = new ArrayList<PVector>(); //all bundles belonging to a single kabadiwala
ArrayList<ArrayList<PVector>> allBundles = new ArrayList<ArrayList<PVector>>(); //all bundles in the animation

int randomKIndex;
int randomMIndex;
int randomWIndex;

///////////////////////// Choose Functions //////////////////////////////
/* 
These functions choose Kabadiwalas as the origins of the path, 
and Sources (of material) as destinations of the path. 
*/

//choose from list of kabadiwalas
void chooseKabadiwala(int i) {
    println("number of kabadiwalas is: ", collection_kcoords.size());
    randomKIndex = i;  
    //choose the kabadiwala corresponding with that index
    kabadiwala_loc = (PVector)collection_kcoords.get(randomKIndex);
    kabadiwala_loc = map.getScreenLocation(kabadiwala_loc);
    println("this kabadiwala's screen location is",kabadiwala_loc);
    }
    
void chooseMRF(int i) {
  randomMIndex = i; 
  mrf_loc = (PVector) collection_mrfcoords.get(randomMIndex);
  mrf_loc = map.getScreenLocation(mrf_loc);
}

void chooseWholesaler(int i) {
  randomWIndex = i; 
  w_loc = (PVector) collection_wcoords.get(randomWIndex);
  w_loc = map.getScreenLocation(w_loc);
  println("this wholesaler's screen location is",w_loc);
}


//now determine a random Source point from collectionOfCollections
void chooseSource(int j) {
  println("entered chooseSource()");
  //make a dictionary with the k_pts json
  //get the point pvector for the K index
  //get the screen location
  //print the screen location
  
  /*
  boolean foundPoint = false;
  while (!foundPoint){
  //get a random index from that list
  int randomIndex = parseInt(random(0, collectionOfCollections.size()));
  //get the segment coordinates of that index
  ArrayList randomSegment = new ArrayList<PVector>();
  randomSegment = collectionOfCollections.get(randomIndex);
  //get the intermediate point between those two points
  PVector pt1 = (PVector)randomSegment.get(0);
  PVector pt2 = (PVector)randomSegment.get(1);

  //generate intermediate points and assign "source"
  PVector intermediates = map.intermediate(pt1, pt2, 0.5);
  source = map.getScreenLocation(intermediates);
  println("found one source");
  HavD = (map.Haversine(map.getGeo(kabadiwala), map.getGeo(source)));
  println("POINTS FOR HAVERSINE: ", map.getGeo(kabadiwala),  map.getGeo(source));
  println("HAVERSINE: ", HavD);
  foundPoint = true;
}
  if(foundPoint ==true) return source;
  else
  {
    print("no points within 3km found");
    return null;
  }
  */
}

/////////////DISPLAY/////////////////

//display the kabadiwala origins
void displayKabadiwala() {
  stroke(color(255, 255, 255));
  noFill();
  polygon(kabadiwala_loc.x, kabadiwala_loc.y, 3, 4);
}
