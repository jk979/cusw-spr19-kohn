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
  size(450,750);
  //initialize data structures
  //map = new MercatorMap(width, height, 19.2904, 18.8835,72.7364,73.0570, 0);

  map = new MercatorMap(width, height, 19.0942,19.0391, 72.8143,72.8462, 0);
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  pois = new ArrayList<POI>();
  
  //load and parse data in setup
  loadData();
  parseData();
  
  //initialize model and simulation
  //initModel();
  
}

void draw(){
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
