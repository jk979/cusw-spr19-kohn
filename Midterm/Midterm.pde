//midterm assignment

//done: base map and kabadiwala points
//to do: agent movements between kabadiwala points and random sources + kabadiwala and mrf

//Background 

//make Bandra map
MercatorMap map; 
PImage background;

//declare GIS-style objects
ArrayList<POI> pois;
ArrayList<Way> ways;
ArrayList<Polygon> polygons;

///////////////////////

//set up GUI
String title = "Kabadiwala Simulation";
String project = "Description here";

//scrollbars (horizontal and vertical)
HScrollbar hs;

// Drag Functions
XYDrag drag;

boolean showUI = true;

/////////////////////////


//contain the model initialization
void initModel(){

  //1. initialize the network using one of these methods
  randomNetwork(0.5);
  //waysNetwork(ways);
  //randomNetworkMinusBuildings(0.1, polygons);
  
  //2. initialize paths using one of these methods
  randomPaths(3);
  //poiPaths(3);
  
  //3. initialize population
  initPopulation(30*paths.size());
}

void setup(){
  size(450,750); //add ,P3D to make it 3D
  //initialize data structures
  //map = new MercatorMap(width, height, 19.2904, 18.8835,72.7364,73.0570, 0);

  map = new MercatorMap(width, height, 19.0942,19.0391, 72.8143,72.8462, 0);
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  pois = new ArrayList<POI>();
  
  //load and parse data in setup
  loadData();
  parseData();
  chooseRandomSource();
  //initialize model and simulation
  //initModel();
  
  /*
  hs = new HScrollbar(width - int(height*MARGIN) - int(0.3*height), int((1-1.5*MARGIN)*height), int(0.3*height), int(MARGIN*height), 5);
  camRotation = hs.getPosPI(); // (0 - 2*PI)
  */
  
}

void draw(){
  
  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  
  background(0);
  drawGISObjects();
 
  //draw mrfs
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
  
  //draw kabadiwalas
  for(int i=0; i<kData.getRowCount()-1; i++){
     k_array.get(i).draw();
  }
  noLoop();
}


////////////////////////////////////

/*
Classes Contained: 

  Pathfinder() - calculates shortest path between Source and Kabadiwala
  ObstacleCourse() - multiple Obstacles including Buildings
  Obstacle() - 2D polygon that detects overlap events
  Graph() - Network of nodes and weighted edges
  Node() - Fundamental building block of Graph()
  
Standard GIS shapes: 
  POI() - Points
  Way() - lines (streets, paths, etc)
  Polygons() - buildings, parcels, etc. 

*/

////////////
/*
Each Agent gets 1 randomly generated Garbage to pick up. 
1. Generate the 1 garbage along node-edge network for each agent. 
for each agent: 
- find shortest path between agent and garbage
- move on that path to the garbage
- when collision detection between agent and garbage, garbage location = agent location - some radius
- after collision detection, agent receives Rupees and reverses path
- when collision detection between agent and shop, agent prints "Collected!"
*/
