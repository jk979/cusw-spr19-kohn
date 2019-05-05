//bundles and source must be linked

//make Bandra map
MercatorMap map; 
String whichBackground;
int k_min;
int k_max;
int m_min; 
int m_max;
int w_min; 
int w_max;

PImage background;
PGraphics pg;
ArrayList<String> day = new ArrayList<String>();
String currentDay;

//declare inactive GIS-style objects
ArrayList<POI> pois;
ArrayList<Way> ways;
ArrayList<Polygon> polygons;

//declare active GIS objects
ArrayList<POI_hh> poi_hh_array;
Map<String,PVector> hh_endpoint_map = new HashMap<String,PVector>(); //to look up the corresponding hh endpoint by kabadiwala/endpoint ID

int bundlesCollected;

boolean soldToKabadiwala;
boolean roundtripCompleted;
int j;

Bundle b;

//temporary array for number of bundles created
ArrayList<Bundle> bundleArray = new ArrayList(); 
ArrayList<KabadiwalaAgent> kabadiwalaArray = new ArrayList(); 
ArrayList<MRFAgent> mrfArray = new ArrayList(); 
ArrayList<WholesalerAgent> wholesalerArray = new ArrayList(); 

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
  
  //Number of groups 
  println("entering group for loop");
    //what map are we in?
    if(whichBackground == "0"){
      k_min = 0;
      k_max = 162;
      m_min = 0;
      m_max = 39;
      w_min = 0;
      w_max = 3;
    }
    else if(whichBackground == "HW"){
      //test
      k_min = 2; 
      k_max = 3; //testing one at a time
      m_min = 16;
      m_max = 18;
      w_min = 1;
      w_max = 2;
      //when ready for complete
      //k_min = 0; 
      //k_max = 66;
    }
    else if(whichBackground == "N"){
      k_min = 67; 
      k_max = 112;
      m_min = 36;
      m_max = 37;
      w_min = 0;
      w_max = 1;
    }
    else if(whichBackground == "RN"){
      k_min = 113;
      k_max = 162;
      m_min = 29;
      m_max = 31;
      w_min = 2;
      w_max = 3;
    }
    
    //set up the kabadiwalas
    for(int i = k_min ; i<k_max; i++){
      chooseKabadiwala(i); //choose the #i kabadiwala agent
      //initialize the agent on screen
      KabadiwalaAgent k = new KabadiwalaAgent(kabadiwala_loc.x, kabadiwala_loc.y);
      kabadiwalaArray.add(k);
      
      println("chose kabadiwala #",i+1);
        //initialize 0 for each variable
           roundtripKM = 0;
           totalKPickupCost = 0;
           kabadiwala_pickup_cost_paper = 0;
           kabadiwala_pickup_cost_plastic = 0;
           kabadiwala_pickup_cost_glass = 0;
           kabadiwala_pickup_cost_metal = 0;
           misc = 0;
           
        //set up each kabadiwala's bundles
        for(int j = 0; j<numBundlesPerKabadiwala; j++){ //how many bundles one kabadiwala should get
          roundtripCompleted = false;
          String composite_ID = str(i+1)+"-"+str(j+1);      
          println("composite ID: ",composite_ID);
          //make a kPath for kabadiwala, mutable Source, and bundle

          //get the path for the composite ID
          //println("the path for these guys is : "+composite_ID + "//" + mergedMap.get(composite_ID));
          // [ [ [x,y],[x,y] ] , [ [x,y],[x,y] ] ]
          //for(ArrayList<PVector> s : mergedMap.get(composite_ID)){
          //  println(composite_ID,"//",mergedMap.get(composite_ID));
          //  Way way = new Way(s);
          //  way.HH_paths = true;
          //  ways.add(way);
          //}
          //waysNetwork(ways);
          
          //find point at end of path and assign Bundle to its location
          PVector bundlepoint = hh_endpoint_map.get(composite_ID);
          println("composite ID ",composite_ID, " has endpoint location: ",bundlepoint);
          b = new Bundle(map.getScreenLocation(bundlepoint));
          b.id = composite_ID; //bind to ID
          
          //add to bundleArray for displaying in draw()
          bundleArray.add(b);
          //trying to display the endpoint
          //POI_hh h = new POI_hh(hh_endpoint);
          //poi_hh_array.add(h);
       
          //makeCompletePathFromKabadiwala();
          
          //initialize population
          //println("path size is",paths.size());
          //initPopulation(1);
          //Let go of the bundle 
        }
    }
        
    //set up Level 2
  
    for(int i = m_min ; i<m_max; i++){
      chooseMRF(i);
      MRFAgent m = new MRFAgent(mrf_loc.x, mrf_loc.y);
      mrfArray.add(m);
    }
    for(int i = w_min ; i<w_max; i++){
      chooseWholesaler(i);
      WholesalerAgent w = new WholesalerAgent(w_loc.x, w_loc.y);
      wholesalerArray.add(w);
    }
}

//////////////////////////////////// setup /////////////////////////////////////

void setup(){
  size(1250,750); //add ,P3D to make it 3D
  addDays();
  //add background graphic to place GIS objects on
  pg = createGraphics(width, height);
    
  //draw the map with given dimensions
  int width_map = 450;
  int height_map = height;
  
  //map extents
  whichBackground = "HW";
  
  if(whichBackground == "HW"){
    //map = new MercatorMap(width_map, height_map, 19.0926, 19.0402, 72.7740, 72.8507,0);
    map = new MercatorMap(width_map, height_map, 19.0942, 19.0391, 72.8143, 72.8462, 0); //bandra
  }
  else if(whichBackground == "RN"){
    map = new MercatorMap(width_map+700, height_map, 19.2729, 19.2322, 72.8309, 72.8989, 0); //dahisar
  }
  else if(whichBackground == "N"){
    map = new MercatorMap(width_map, height_map-400, 19.1213, 19.0545, 72.8787, 72.9612, 0); //ghatkopar
  }
  else if(whichBackground == "0"){
    map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0); //mumbai complete
  }
  
  String whichMap;
  whichMap = "speeds";
  
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
    loadRailways();
    parseRailways();
    
    //loadBuildings();
    //parseBuildings();
  }
  /*
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
  }*/
  else if(whichMap == "speeds"){
    loadDataSpeeds();
    //initialize attributes
    polygons = new ArrayList<Polygon>();
    ways = new ArrayList<Way>();
    pois = new ArrayList<POI>();
    load_k_mrf();
    parseSpeeds();
    
    loadHHtoKabadiwala();
    parseHHtoKabadiwala();
    parseHHPoints();
    
    loadWardBoundaries();
    
    parseWardBoundaries();
    loadRailways();
    parseRailways();
  }
  
  println("initializing model...");
  //initialize model and simulation
  initModel();
  
  println("now beginning to draw gis objects...");
  pg.beginDraw();
  //pg.background(0);
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  println("ended drawing gis objects");
  
}

////////////////////////////////draw////////////////////////////////////

void draw(){
  //includes drawing background, MRFs, kabadiwalas, path, bundle of materials, agents, testing if the agent has reached or dropped off the bundle, and wholesalers
  
  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  background(0);
  image(pg, 0,0);
  
 //draw each of the mrf shops
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }

 //draw each of the kabadiwala shops
  for(int i =0 ; i<k_array.size(); i++){
    k_array.get(i).draw();
  }
  
  //draw each of the poi_hh
  /*
  for(int i = 0; i<poi_hh_array.size(); i++){
    poi_hh_array.get(i).draw();
  }
  */
  
  
  /*
  for(Path p : paths){
     p.displayDebug(255, 0);
  }
  */
  
  checkAgentBehavior();
  checkSaleBehavior();
  
  //draw each of the bundles
  for(int i = 0; i<bundleArray.size(); i++){
    Bundle Bn = (Bundle) bundleArray.get(i);
    Bn.display();
    //text("Weight: "+Bn.total_kg, Bn.w, Bn.h);
  }
  
  //draw the kabadiwala's path
  
  
  //draw the KABADIWALA!
  for(int i = 0; i<kabadiwalaArray.size(); i++){
    KabadiwalaAgent k = (KabadiwalaAgent) kabadiwalaArray.get(i);
    k.display();
  }
  
  //draw the MRF agent!
  for(int i = 0; i<mrfArray.size(); i++){
    MRFAgent m = (MRFAgent) mrfArray.get(i);
    m.display();
  }
  
  //draw the wholesaler!
  for(int i = 0; i<wholesalerArray.size(); i++){
    WholesalerAgent w = (WholesalerAgent) wholesalerArray.get(i);
    w.display();
  }
  
  drawInfo();  
  //noLoop();
}

void addDays(){
day.add("Monday");
day.add("Tuesday");
day.add("Wednesday");
day.add("Thursday");
day.add("Friday");
day.add("Saturday");
println(day);
}

void keyPressed(){
    if(key==ENTER || key==RETURN){
      initModel();
  }
  else if(key=='q'){
    square = !square;
  }
  else if(key=='z'){
    whichBackground = "HW";
  }
  else if(key=='x'){
    whichBackground = "N";
  }
  else if(key=='c'){
    whichBackground = "RN";
  }
  else if(key=='v'){
    whichBackground = "0";
  }
}

void keyTyped(){
  if(key == '1'){
    currentDay = day.get(0);
  }
  else if(key == '2'){
    currentDay = day.get(1);
  }
  else if(key == '3'){
    currentDay = day.get(2);
  }
  else if(key == '4'){
    currentDay = day.get(3);
  }
  else if(key == '5'){
    currentDay = day.get(4);
  }
  else if(key == '6'){
    currentDay = day.get(5);
  }
  else if(key == '7'){
    currentDay = day.get(6);
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
