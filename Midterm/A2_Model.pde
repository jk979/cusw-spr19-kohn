// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;

import java.util.*;
float laps; 


//  Object to define and capture a specific origin, destiantion, and path
ArrayList<Path> paths = new ArrayList<Path>();

//  Objects to define agents that navigate our environment
ArrayList<Agent> people = new ArrayList<Agent>();

//ways network using roads as ways
void waysNetwork(ArrayList<Way> w) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution, w);
}

//draw a shortest path between the kabadiwala and the source
void kPath() {
  println("kPath is running");
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */

          
    // Searches for valid paths only
    boolean notFound = true;
    
    while(notFound) {

      //1. choose the points for the kabadiwala and for the source
        numKabadiwalas = 1;
        numBundlesPerKabadiwala = 2; 
        for (int i = 0; i<numKabadiwalas; i++){ //for one kabadiwala...
          chooseKabadiwala();
          //initially, hasn't collected any yet
          bundlesCollected = 0;
          for (int j = 0; j<numBundlesPerKabadiwala; j++){ //there is one bundle...
            //println(bundles.get(i).get(j)); //bundles should be an arraylist of arraylist
            bundle = chooseSource(); //gets "source" <-- destination
            println("destination location: " + source);
            println("bundle location: " + bundle);
            
      //2. identify the path between these two points
            Path a = new Path(kabadiwala, source);
            println("pathSource: " + source);
        
      //3. solve the path
        a.solve(finder);
            //a.straightPath();

            if(a.waypoints.size() > 1 && a.waypoints.get(a.waypoints.size()-1) == source) {
              //println( a.waypoints.get(a.waypoints.size()-1), source);
              notFound = false;
              paths.add(a);
            }
          }
        }
        
      //midterm: send the agent out and do the following: 
      
      //5. come back with the bundle
      //check if bundle_released = false, means it's grabbed the bundle
      //if so, laps = 1
      
      //make bundle at source (done)
      //make bundle with agent
      //make bundle at kabadiwala
      //bundle.x = kabadiwala.x;
      //bundle.y = kabadiwala.y;
            
      
     
      
      
      //next bundle!
      
  } //end 
  println("paths: ", paths.size());
} //end KPaths

      
//draws a path that hits 10 kabadiwalas using the shortest distance between them and the Wholesaler/MRF
void WholesalerPath(){ 
//option 1. wholesaler is picking up
//origin = wholesaler point on map

//option 2. MRF is picking up
//origin = MRF point on map

//from the list of kabadiwalas, divide them into groups of 3
//for each group: 
//check if all of them have bundles in their shops
//get the shortest distance linking all of them with Wholesaler point as origin and destination
//run the path using an agent and pick up all the materials
//stop when you reach the Wholesaler point again

}

void initPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  people = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    int random_index = int(random(paths.size()));
    Path random_path = paths.get(random_index);
    if (random_path.waypoints.size() > 1) {
      int random_waypoint = 0;//int(random(random_path.waypoints.size()));
      //float random_speed = random(0.1, 0.3);
      float random_speed = 0.7;
      PVector loc = random_path.waypoints.get(random_waypoint);
      Agent person = new Agent(loc.x, loc.y, 7, random_speed, random_path.waypoints);
      person.id = people.size();
      people.add(person);
      person.pathToDraw = random_path;
      //Only call the first person of each group to life 
      if(people.size() == 1 || people.size() == 1) person.isAlive = true;
      else person.isAlive= false;
    }
    
  }
  println("People in system: ", people.size());
}

ArrayList<PVector> personLocations(ArrayList<Agent> people) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: people) {
    l.add(a.location);
  }
  return l;
}
