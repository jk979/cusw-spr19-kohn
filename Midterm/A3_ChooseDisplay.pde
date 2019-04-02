//drawing paths
PVector randomKabadiwala = new PVector();
PVector randomSource = new PVector();
PVector each_kabadiwala = new PVector();
PVector each_source = new PVector();
PVector bundle = new PVector();
int euclideanAgentBundle;
int euclideanOriginBundle;


///////////////////////// Choose Functions //////////////////////////////
/* These functions choose Kabadiwalas as the start points of the path, and Sources (of material) as the end points of the path. */

//build all the kabadiwala origins instead of a random kabadiwala
void chooseAllKabadiwalas(){
 for(int q = 0; q<collection_kcoords.size()-1; q++){
  //get the index of each row
  int index = q;
  each_kabadiwala = (PVector)collection_kcoords.get(index);
  each_kabadiwala = map.getScreenLocation(each_kabadiwala);
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

//build a random kabadiwala origin
//chooses from big list of 199 kabadiwalas. May not show up on the small Bandra map for every run. 
void chooseRandomKabadiwala() {
  boolean foundPoint = false;
  while(!foundPoint){
    println("Random kabadiwala chosen from: "+collection_kcoords.size()); //kcoords is global
    //get a random index from the list of kabadiwalas
    int randomKIndex = parseInt(random(0, collection_kcoords.size()));
    println("the random KIndex is "+randomKIndex); 
    //choose the kabadiwala corresponding with that index
    randomKabadiwala = (PVector)collection_kcoords.get(randomKIndex);
    randomKabadiwala = map.getScreenLocation(randomKabadiwala);
        
    //get the distance between the random Kabadiwala and the random Source
    HavD = (map.Haversine(map.getGeo(randomKabadiwala), map.getGeo(randomSource)));
    if(HavD <= dist_from_shop){ //ensures distance is <= 3km from the kabadiwala shop
        println("Haversine is: ", (map.Haversine(map.getGeo(randomKabadiwala), map.getGeo(randomSource))));
        foundPoint = true;
    }
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

/////////////DISPLAY/////////////////
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

//display the kabadiwala origins
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
