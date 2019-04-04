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

int euclideanAgentBundle;
int euclideanOriginBundle;
int euclideanAgentSource;
int euclideanAgentOrigin;
int randomKIndex;


///////////////////////// Choose Functions //////////////////////////////
/* These functions choose Kabadiwalas as the start points of the path, and Sources (of material) as the end points of the path. */

//build kabadiwala origin

//chooses from big list of 199 kabadiwalas. May not show up on the small Bandra map for every run. 
void chooseKabadiwala() {
  boolean foundPoint = false;
  while (!foundPoint) {
    //  println("Random kabadiwala chosen from: "+collection_kcoords.size()); //kcoords is global
    //get a random index from the list of kabadiwalas
    randomKIndex = parseInt(random(0, collection_kcoords.size()));
    // randomKIndex = 64;  
    //choose the kabadiwala corresponding with that index
    kabadiwala = (PVector)collection_kcoords.get(randomKIndex);
    kabadiwala = map.getScreenLocation(kabadiwala);

    //get the distance between the random Kabadiwala and the random Source, make sure it's 3km or less
    HavD = (map.Haversine(map.getGeo(kabadiwala), map.getGeo(source)));
    if (HavD <= dist_from_shop) { //ensures distance is <= 3km from the kabadiwala shop
      println("Kabadiwala to Source distance is: ", (map.Haversine(map.getGeo(kabadiwala), map.getGeo(source)))/1000, " km");
      foundPoint = true;
    }
    //displayKabadiwala();
  }
}

//now determine a random Source point from collectionOfCollections
PVector chooseSource() {
  PVector temp; 
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
  PVector pt1 = (PVector)randomSegment.get(0);
  PVector pt2 = (PVector)randomSegment.get(1);

  //generate intermediate points and assign "source"
  PVector intermediates = map.intermediate(pt1, pt2, 0.5);
  source = map.getScreenLocation(intermediates);
  temp = map.getScreenLocation(intermediates);

  return temp; //creates temporary instance of the source point
  //bundle = map.getScreenLocation(intermediates);

  //once chosen, display the source (not necessary because we have origin/destination points overlaid already)
}

/////////////DISPLAY/////////////////

//display the kabadiwala origins
void displayKabadiwala() {
  stroke(color(255, 255, 255));
  noFill();
  polygon(kabadiwala.x, kabadiwala.y, 3, 4);
}
