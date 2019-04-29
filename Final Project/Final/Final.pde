//midterm assignment

/*
Bugs left: 
initModel -- is the ways network changing? Do you have to re-chose any data structures?
while loop exit condition/choosing -- are there options that shouldn't be chosen together, etc? 
*/

//bundles and source must be linked

//make Bandra map
MercatorMap map; 
PImage background;
PGraphics pg;

//declare GIS-style objects
ArrayList<POI> pois;
ArrayList<Way> ways;
ArrayList<Polygon> polygons;

int bundlesCollected;
int numKabadiwalas; 
int numBundlesPerKabadiwala;

boolean soldToKabadiwala;
boolean roundtripCompleted;
int j;

///////////////////////

//set up GUI
String title = "Kabadiwala Simulation";
String project = "Description here";

//scrollbars (horizontal and vertical)

boolean showUI = true;

/////////////////////////

//contain the model initialization
void initModel(){
  soldToKabadiwala = false;

  //1. Initialize the network
  println("NOT initializing ways network"); //because the paths along the network are already chosen
  //waysNetwork(ways); //initialize the Ways network (roads)
  
  //2. Initialize origin/destination and paths for kabadiwalas using kPath() method
  int numKabadiwalas = 1;
  int numBundlesPerKabadiwala = 3;
  println("NK = "+numKabadiwalas+ " and NB = "+numBundlesPerKabadiwala);
  
  //Number of groups 
  println("entering group for loop");
    //kabadiwala IDs
    for(int i = 1 ; i<2; i++){
        chooseKabadiwala(100); //choose the #i kabadiwala agent
        println("chose kabadiwala");
        //initialize 0 for each variable
           roundtripKM = 0;
           totalKPickupCost = 0;
           kabadiwala_pickup_cost_paper = 0;
           kabadiwala_pickup_cost_plastic = 0;
           kabadiwala_pickup_cost_glass = 0;
           kabadiwala_pickup_cost_metal = 0;
           misc = 0;
        //repeat below 
        for(int j = 1; j<2; j++){ //how many bundles one kabadiwala should get
        println("J IS: ",j);
          roundtripCompleted = false;
          //make a kPath for kabadiwala, mutable Source, and bundle
          //makeCompletePathFromKabadiwala();
          
          //build path
          //i is the kabadiwala ID
          //j is the point ID
          
          //concatenate I and J to find the appropriate destination and path
          
          
          //build endpoint
          
          
          //set bundle id 
         // b.id = j;
         // println("attaching bundle id #"+b.id+" to source location");
         
          //initialize population
          //println("path size is",paths.size());
          //initPopulation(1);
          //Let go of the bundle 
        }
    }
}

//////////////////////////////////// setup /////////////////////////////////////

void setup(){
  size(1250,750); //add ,P3D to make it 3D

  //add background graphic to place GIS objects on
  pg = createGraphics(width, height);
    
  //draw the map with given dimensions
  int width_map = 450;
  int height_map = height;
  
  //map extents
  String whichBackground;
  whichBackground = "HW";
  
  if(whichBackground == "HW"){
    map = new MercatorMap(width_map, height_map, 19.0942, 19.0391, 72.8143, 72.8462, 0); //bandra
  }
  else if(whichBackground == "RN"){
    map = new MercatorMap(width_map+500, height_map, 19.2729, 19.2322, 72.8309, 72.8989, 0); //dahisar
  }
  else if(whichBackground == "N"){
    map = new MercatorMap(width_map, height_map, 19.1213, 19.0545, 72.8787, 72.9612, 0); //ghatkopar
  }
  else if(whichBackground == "0"){
    map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0); //mumbai complete
  }
  
  String whichMap;
  whichMap = "bandra";
  
  if(whichMap == "bandra"){
    loadDataBandra();
    //initialize attributes
    polygons = new ArrayList<Polygon>();
    ways = new ArrayList<Way>();
    pois = new ArrayList<POI>();
    load_k_mrf();
    parseData();
    loadHHtoKabadiwala();
    parseHHtoKabadiwala();
    parseHHPoints();
    loadWardBoundaries();
    parseWardBoundaries();
  }
  else if(whichMap == "OSMNX"){
    loadDataOSMNX();
    //initialize attributes
    polygons = new ArrayList<Polygon>();
    ways = new ArrayList<Way>();
    pois = new ArrayList<POI>();
    load_k_mrf();
    parseOSMNX();
  }
  else if(whichMap == "DataMumbai"){
    loadDataMumbai();
    //initialize attributes
    polygons = new ArrayList<Polygon>();
    ways = new ArrayList<Way>();
    pois = new ArrayList<POI>();
    load_k_mrf();
    parseDataMumbai();
  }
  else if(whichMap == "speeds"){
    loadDataSpeeds();
    //initialize attributes
    polygons = new ArrayList<Polygon>();
    ways = new ArrayList<Way>();
    pois = new ArrayList<POI>();
    load_k_mrf();
    parseSpeeds();
  }
  
  println("now beginning to draw gis objects...");
  pg.beginDraw();
  //pg.background(0);
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  println("ended drawing gis objects");
  

  //initialize model and simulation
  initModel();
  
}

////////////////////////////////draw////////////////////////////////////

void draw(){
  //includes drawing background, MRFs, kabadiwalas, path, bundle of materials, agents, testing if the agent has reached or dropped off the bundle, and wholesalers
  
  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  background(0);
  image(pg, 0,0);
 //draw mrfs
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
 
 //draw each of the kabadiwalas
  for(int i =0 ; i<k_array.size(); i++){
    k_array.get(i).draw();
  }
  
  drawInfo();  
  
  /*
  for(Path p : paths){
     p.displayDebug(255, 0);
  }
  */
  
  checkAgentBehavior();
  checkSaleBehavior();
    
  //noLoop();
}

void addDays(){
ArrayList<String> day = new ArrayList<String>();
day.add("Monday");
day.add("Tuesday");
day.add("Wednesday");
day.add("Thursday");
day.add("Friday");
day.add("Saturday");
//println(day);
}

void keyPressed(){
    if(key==ENTER || key==RETURN){
      initModel();
  }
  else if(key=='1'){
    //text("Day: "+day.get(0), 1100, 70);
  }
  else if(key=='2'){
    text("Day: Tuesday",1100,70);
  }
}

//each day: 10 routes for each kabadiwala

//if 1 pressed: Monday
//if 2 pressed: Tuesday (+plastic picked up)
//if 3 pressed: Wednesday
//if 4 pressed: Thursday (+plastic picked up)
//if 5 pressed: Friday
//if 6 pressed: Saturday

////////////////////////////////////

/*
Classes Contained: 

  Pathfinder() - calculates shortest path between Source and Kabadiwala
  ObstacleCourse() - multiple Obstacles including Buildings
  Obstacle() - 2D polygon that detects overlap events
  Graph() - Network of nodes and weighted edges
  Node() - Fundamental building block of Graph()
  Bundle() - Fundamental building block which contains paper, plastic, glass, and metal for pickup
  
Standard GIS shapes: 
  POI() - Points
  Way() - lines (streets, paths, etc)
  Polygons() - buildings, parcels, etc. 

*/

////////////
/*
Completed: 
Each Agent gets 1 randomly generated Garbage to pick up. ***DONE***
1. Generate the 1 garbage along node-edge network for each agent. ***DONE***
for each agent: 
- find shortest path between agent and garbage ***DONE***
- move on that path to the garbage ***DONE***
- when collision detection between agent and garbage, garbage location = agent location - some radius ***DONE***
- after collision detection, agent receives Rupees and reverses path ***DONE***
- when collision detection between agent and shop, agent stops moving, task complete ***DONE***
- profit++; ***DONE***
- measure total distance traveled ***DONE***
- limit appearance of Sources to less than 2km network distance in any direction from the kabadiwala ***DONE***
-----------------------------------
In Progress: 
- convert OSMNX simplified road network to a GeoJSON and add it here -- need to convert from the annoying 7 digit format to decimal degree first, then export to GeoJSON
- draw all kabadiwalas and paths at once, to get aggregate for system
- add up aggregate Profit and aggregate Distance
class of Wholesalers: 
- defined by 1) capacity of truck, 2) frequency of pickup, 3) behavior in picking up from as many kabadiwala as possible until their truck is full, 
dropoff at either Dharavi (Wholesaler) or the nearest MRF (RaddiConnect)
- add Wholesalers
- add RaddiConnect

*/

/*fclasses: 
- residential
- forest
- park 
- commercial
- nature_reserve
- farm
- recreation_ground
- industrial
- beach
- cliff
- rail
- river
- wetland
*/
