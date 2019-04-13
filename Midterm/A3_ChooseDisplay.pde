//drawing paths
PVector kabadiwala = new PVector();
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

///////////////////////// Choose Functions //////////////////////////////
/* 
These functions choose Kabadiwalas as the origins of the path, 
and Sources (of material) as destinations of the path. 
*/

//choose from list of kabadiwalas
void chooseKabadiwala() {
    println("number of kabadiwalas is: ", collection_kcoords.size());
    //random index parses for #3, but not for many within the coordinates.
    //made new points that are snapped to the "speeds" roads, but haven't been able 
    //to try yet on "speeds" network
    //randomKIndex = parseInt(random(0, collection_kcoords.size()));
    randomKIndex = 3;  
    //choose the kabadiwala corresponding with that index
    kabadiwala = (PVector)collection_kcoords.get(randomKIndex);
    kabadiwala = map.getScreenLocation(kabadiwala);
    }

//now determine a random Source point from collectionOfCollections
PVector chooseSource() {
  println("entered chooseSource()");
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
  foundPoint = true;
}
  if(foundPoint ==true) return source;
  else
  {
    print("no points within 3km found");
    return null;
  }
}

/////////////DISPLAY/////////////////

//display the kabadiwala origins
void displayKabadiwala() {
  stroke(color(255, 255, 255));
  noFill();
  polygon(kabadiwala.x, kabadiwala.y, 3, 4);
}
