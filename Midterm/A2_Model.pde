// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;

//  Object to define and capture a specific origin, destiantion, and path
ArrayList<Path> paths;

//  Objects to define agents that navigate our environment
ArrayList<Agent> people;

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
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  paths = new ArrayList<Path>();
  int numPaths = 1; //draw only one shortest path 
  int agentsWanted = 3;
  for(int j = 0; j<agentsWanted; j++){
  for (int i=0; i<numPaths; i++) {
    
    // Searches for valid paths only
    boolean notFound = true;
    
    while(notFound) {

      //1. choose the points for the kabadiwala and for the source
      //println("using randomK and randomSource");
      //chooseRandomKabadiwala();
      //chooseRandomSource();
        chooseRandomKabadiwala(); //gets "kabadiwala" <-- origin 
        chooseRandomSource(); //gets "source" <-- destination
      //chooseAllSources();
      
      //2. identify the path between these two points
        Path p = new Path(kabadiwala, source);
      
      //3. solve the path
        p.solve(finder);
      
      if(p.waypoints.size() > 2) {
        notFound = false;
        paths.add(p);
      }
      
     //display the kpoints and sources 
      //displayKabadiwala();
      //displaySource();
   }
  }
  }
  println("paths: ", paths.size());
}

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
      int random_waypoint = 1;//int(random(random_path.waypoints.size()));
      //float random_speed = random(0.1, 0.3);
      float random_speed = 0.7;
      PVector loc = random_path.waypoints.get(random_waypoint);
      Agent person = new Agent(loc.x, loc.y, 7, random_speed, random_path.waypoints);
      people.add(person);
    }
  }
}

ArrayList<PVector> personLocations(ArrayList<Agent> people) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: people) {
    l.add(a.location);
  }
  return l;
}
