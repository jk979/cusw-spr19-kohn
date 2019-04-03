//drawing paths
PVector kabadiwala = new PVector();
PVector source = new PVector();
//PVector each_kabadiwala = new PVector();
//PVector each_source = new PVector();
PVector bundle = new PVector();
int euclideanAgentBundle;
int euclideanOriginBundle;
int randomKIndex;


///////////////////////// Choose Functions //////////////////////////////
/* These functions choose Kabadiwalas as the start points of the path, and Sources (of material) as the end points of the path. */

//build kabadiwala origin

//chooses from big list of 199 kabadiwalas. May not show up on the small Bandra map for every run. 
void chooseKabadiwala() {
  boolean foundPoint = false;
  while(!foundPoint){
  //  println("Random kabadiwala chosen from: "+collection_kcoords.size()); //kcoords is global
    //get a random index from the list of kabadiwalas
    //randomKIndex = parseInt(random(0, collection_kcoords.size()));
    randomKIndex = 64;  
  //  println("the random KIndex is "+randomKIndex); 
    //choose the kabadiwala corresponding with that index
    kabadiwala = (PVector)collection_kcoords.get(randomKIndex);
    kabadiwala = map.getScreenLocation(kabadiwala);
        
    //get the distance between the random Kabadiwala and the random Source
    HavD = (map.Haversine(map.getGeo(kabadiwala), map.getGeo(source)));
    if(HavD <= dist_from_shop){ //ensures distance is <= 3km from the kabadiwala shop
        println("Kabadiwala to Source distance is: ", (map.Haversine(map.getGeo(kabadiwala), map.getGeo(source)))/1000," km");
        foundPoint = true;
    }
    //displayKabadiwala();
  }
}

//now determine a random Source point from collectionOfCollections
void chooseSource() {
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
  bundle = map.getScreenLocation(intermediates);
  
  displayBundle();
  //once chosen, display the source (not necessary because we have origin/destination points overlaid already)
  
}

/////////////DISPLAY/////////////////

//display the kabadiwala origins
void displayKabadiwala() {
  stroke(color(255, 255, 255));
  noFill();
  polygon(kabadiwala.x, kabadiwala.y, 3, 4);
}

void displaySource() {
  fill(color(255, 0, 0));
  noStroke();
  polygon(source.x, source.y, 6, 3);
}

void displayBundle() {
  stroke(color(255, 255, 0));
  noFill();
  ellipse(bundle.x, bundle.y, 13, 13);
}
