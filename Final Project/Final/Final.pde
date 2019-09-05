//bundles and source must be linked
//make arraylist of arraylist of arraylists

boolean pacman;

//make Bandra map
MercatorMap map; 
String whichBackground;

int k_min, k_max, m_min, m_max, w_min, w_max;
/*
int k_min = 0;
int k_max = 162;
int m_min = 0;
int m_max = 39;
int w_min = 0;
int w_max = 3;
*/

PImage background;
PGraphics pg;
ArrayList<String> day = new ArrayList<String>();
String currentDay;

//declare inactive GIS-style objects
ArrayList<POI> pois;
ArrayList<Way> ways;
ArrayList<Polygon> polygons;
ArrayList<Pathway> pathways; //the specific path the agents will travel

//declare active GIS objects
ArrayList<POI_hh> poi_hh_array;
Map<String, PVector> hh_endpoint_map = new HashMap<String, PVector>(); //to look up the corresponding hh endpoint by kabadiwala/endpoint ID

int bundlesCollected;

boolean soldToKabadiwala;
boolean roundtripCompleted;
int j;

//temporary array for number of bundles created
ArrayList<Bundle> bundleArray = new ArrayList(); 

//make new graphArray which keeps track of the kabadiwala distances in the system; globally accessible
ArrayList<Float> graphArray = new ArrayList<Float>();
float totalTripDistanceForKabadiwala; //globally initialized but locally defined

ArrayList<Agent> kabadiwalaArmy = new ArrayList();
ArrayList<Agent2> mrfArmy = new ArrayList(); 
ArrayList<Agent2> wholesalerArmy = new ArrayList(); 
ArrayList<Float> hhDistArray = new ArrayList<Float>();

///////////////////////

//set up GUI
String title = "Kabadiwala Simulation";
String project = "Description here";

//scrollbars (horizontal and vertical)

boolean showUI = true;

/////////////////////////

void tempModel(){
  soldToKabadiwala = false;
  println("activating temp model...");
  
  //1. initialize the Kabadiwala Army
  initPopulation(); 
  
}


//////////////////////////////////// setup /////////////////////////////////////

//initial variables for map
int width_map = 600;
int height_map = height+650;
float scalarForMap_a = 19.2904;
float scalarForMap_b = 18.8835;
float scalarForMap_c = 72.7364;
float scalarForMap_d = 73.0570;

void setMap(){
  //draw the map with given dimensions
  map = new MercatorMap(width_map, height_map, scalarForMap_a, scalarForMap_b, scalarForMap_c, scalarForMap_d, 0);
}

void setup() {
  size(1250, 750); //add ,P3D to make it 3D //1250,750
  addDays();
  //add background graphic to place GIS objects on
  pg = createGraphics(width, height);
  
  String whichStartingMap = "HW";
  numKabadiwalas = k_max-k_min;
  
  if(whichStartingMap == "HW"){

    width_map = 450;
    scalarForMap_a = 19.0942; 
    scalarForMap_b = 19.0391;
    scalarForMap_c = 72.8143;
    scalarForMap_d = 72.8462;
    setMap();
      
    //set number of actors for HW
    k_min = 0; 
    k_max = 5; //testing one at a time
    m_min = 17;
    m_max = 19;
    w_min = 1;
    w_max = 2;
  }
  
  else if(whichStartingMap == "N"){
    width_map = 600;
    height_map = height - 400;
    scalarForMap_a = 19.1213; 
    scalarForMap_b = 19.0545;
    scalarForMap_c = 72.8787;
    scalarForMap_d = 72.9612;
    setMap();
    
    //set number of actors for N
    k_min = 67; 
    k_max = 112;
    m_min = 36;
    m_max = 37;
    w_min = 0;
    w_max = 1;
    
  }
  
  else if(whichStartingMap == "RN"){
    width_map = 1150;
    scalarForMap_a = 19.2729; 
    scalarForMap_b = 19.2322;
    scalarForMap_c = 72.8309;
    scalarForMap_d = 72.8989;
    setMap();
    
    //set number of actors for RN
    k_min = 113;
    k_max = 162;
    m_min = 29;
    m_max = 31;
    w_min = 2;
    w_max = 3;
  }
  
  else if(whichStartingMap == "0"){
    width_map = 600;
    height_map = height;

    scalarForMap_a = 19.2904; 
    scalarForMap_b = 18.8835;
    scalarForMap_c = 72.7364;
    scalarForMap_d = 73.0570;
    setMap();
    
    //set number of actors for Mumbai
    k_min = 158; //could be 0 for real
    k_max = 162;
    m_min = 0;
    m_max = 39;
    w_min = 0;
    w_max = 3;
    
  }
  
  //load roads
  loadDataSpeeds();
  //initialize attributes
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  pois = new ArrayList<POI>();
  pathways = new ArrayList<Pathway>();
  //load kabadiwala and MRF points CSV
  load_k_mrf();
  parseSpeeds();

  //level 1 paths: households --> kabadiwala
  loadHHtoKabadiwala();
  parseHHtoKabadiwala(); //get full list of HHtoKabadiwala paths
  parseHHPoints();
  parseHHdist();

  //level 2 paths: kabadiwala --> MRF
  loadKabadiwalaToMRF();
  parseKabadiwalaToMRF();

  loadWardBoundaries();
  parseWardBoundaries();
  loadRailways();
  parseRailways();

  //initialize model and simulation
  println("initializing model...");
  currentDay = day.get(0); //default to Monday
  tempModel();

  //draw the static GIS objects
  println("now beginning to draw gis objects...");
  pg.beginDraw();
  //pg.background(0);
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  println("ended drawing gis objects");
}

////////////////////////////////draw////////////////////////////////////

void drawShops(){
  //draw each of the mrf shops
  for (int i=0; i<mrfData.getRowCount()-1; i++) {
    mrf_array.get(i).draw();
  }

  //draw each of the kabadiwala shops
  for (int i =0; i<k_array.size(); i++) {
    k_array.get(i).draw();
  }
}

void drawBundles(){
    //draw each of the bundles
  for (int i = 0; i<bundleArray.size(); i++) {
    Bundle Bn = (Bundle) bundleArray.get(i);
    Bn.display();
    //text("Weight: "+Bn.total_kg, Bn.w, Bn.h);
  }
}

void drawAgents(){
  //draw the KABADIWALA!
  for (int i = 0; i<kabadiwalaArmy.size(); i++) {
    Agent k = (Agent) kabadiwalaArmy.get(i);
    k.display();
  }

  //draw the MRF agent!
  for (int i = 0; i<mrfArmy.size(); i++) {
    Agent2 m = (Agent2) mrfArmy.get(i);
    m.display();
  }

  //draw the wholesaler!
  for (int i = 0; i<wholesalerArmy.size(); i++) {
    Agent2 w = (Agent2) wholesalerArmy.get(i);
    w.display();
  }
}

void draw() {
  //includes drawing background, MRFs, kabadiwalas, path, bundle of materials, agents, testing if the agent has reached or dropped off the bundle, and wholesalers

  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  background(0);
  image(pg, 0, 0);
  
  //draw each of the poi_hh
  /*
  for(int i = 0; i<poi_hh_array.size(); i++){
   poi_hh_array.get(i).draw();
   }
   */
  drawShops();
  drawAgents();
  drawBundles();
  checkAgentBehavior();
  checkSaleBehavior();
  
  drawInfo();  
  //noLoop();
}

void addDays() {
  day.add("Monday");
  day.add("Tuesday");
  day.add("Wednesday");
  day.add("Thursday");
  day.add("Friday");
  day.add("Saturday");
  println(day);
}

void clearArrays(){
  bundleArray.clear();
  kabadiwalaArmy.clear();
  mrfArmy.clear();
  wholesalerArmy.clear();
  graphArray.clear();
}

void resetModel(){
  //don't need to redraw the map or re-parse

    clearArrays();
    background(0);
    image(pg, 0, 0);

    drawShops();
    drawAgents();
    drawBundles();
      
    tempModel();
    checkAgentBehavior();
    checkSaleBehavior();
    
    drawInfo();
}
void keyPressed() {
  if (key==ENTER || key==RETURN) {
    
    currentDay = day.get(0); //default to Monday
    resetModel();
  } 
 
  else if (key=='q') {
    square = !square;
  } 
  
  else if (key=='e'){
    pacman = !pacman;
  }
  
  else if (key=='z') {     //redraw the GIS objects to HW
    
    clearArrays();
    background(0);
    width_map = 450;
    scalarForMap_a = 19.0942; 
    scalarForMap_b = 19.0391;
    scalarForMap_c = 72.8143;
    scalarForMap_d = 72.8462;
    setMap();
    
    //set number of actors for HW
    k_min = 0; 
    k_max = 12; //testing one at a time for HW max is 66
    m_min = 16;
    m_max = 18;
    w_min = 1;
    w_max = 2;
    
    loadHHtoKabadiwala();
    parseHHtoKabadiwala();
    parseHHPoints();

    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");
    
  } else if (key=='x') {    //redraw the GIS objects to RN
    
    clearArrays();
    background(0);
    width_map = 1150;
    scalarForMap_a = 19.2729; 
    scalarForMap_b = 19.2322;
    scalarForMap_c = 72.8309;
    scalarForMap_d = 72.8989;
    setMap();
    
    //set number of actors for RN
    k_min = 113;
    k_max = 118; //could be 162
    m_min = 29;
    m_max = 31;
    w_min = 2;
    w_max = 3;
    
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");
    
  } else if (key=='c') {    //redraw the GIS objects to N
    
    clearArrays();
    background(0);
    width_map = 600;
    height_map = height - 400;
    scalarForMap_a = 19.1213; 
    scalarForMap_b = 19.0545;
    scalarForMap_c = 72.8787;
    scalarForMap_d = 72.9612;
    setMap();
    
    //set number of actors for N
    k_min = 67; 
    k_max = 72; //could be 112
    m_min = 36;
    m_max = 37;
    w_min = 0;
    w_max = 1;

   
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");

  } else if (key=='v') {    //redraw the GIS objects to Mumbai

    background(0);
    width_map = 600;
    height_map = height;

    scalarForMap_a = 19.2904; 
    scalarForMap_b = 18.8835;
    scalarForMap_c = 72.7364;
    scalarForMap_d = 73.0570;
    setMap();
    
    //set number of actors for N
    k_min = 0; 
    k_max = 10; //could be 162
    m_min = 0;
    m_max = 39;
    w_min = 0;
    w_max = 3;
   
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");

  }
  
  else if (key=='a'){
      println("incrementing up numKabadiwalas by 1 "+numKabadiwalas);
        k_max = k_max + 1; 
        numKabadiwalas = numKabadiwalas+=1;
        resetModel();
    }
    
  else if (key=='s'){
      println("incrementing down numKabadiwalas by 1 "+numKabadiwalas);
      if(numKabadiwalas!=0){
        k_max = k_max - 1;
        numKabadiwalas = numKabadiwalas-=1;
        resetModel();
      }
    }
}

boolean pickingPlastic = false;
boolean pickingPaper = false;
boolean pickingGlass = false;
boolean pickingMetal = false;

boolean wholesalerPlastic = false;
boolean wholesalerPaper = false;
boolean wholesalerGlass = false;
boolean wholesalerMetal = false;

void keyTyped() {
  if (key == '1') { //Monday
    currentDay = day.get(0); //prints currentDay on screen
    
    //MRF schedule
    pickingPlastic = true;
    pickingPaper = true;
    pickingGlass = true;
    pickingMetal = true;
    
    //W schedule
    wholesalerPlastic = true;
    wholesalerPaper = true;
    wholesalerGlass = true;
    wholesalerMetal = true;
    
    //activate model
    resetModel();
    
  } else if (key == '2') { //Tuesday
    currentDay = day.get(1);
    
    //MRF schedule
    pickingPlastic = false;
    pickingPaper = true;
    pickingGlass = false;
    pickingMetal = false;
    
    //W schedule
    wholesalerPlastic = false;
    wholesalerPaper = false;
    wholesalerGlass = false;
    wholesalerMetal = false;
    
    resetModel();

  } else if (key == '3') { //Wednesday
    currentDay = day.get(2);
    
    //MRF schedule
    pickingPlastic = false;
    pickingPaper = true;
    pickingGlass = false;
    pickingMetal = false;
    
    //W schedule
    wholesalerPlastic = false;
    wholesalerPaper = false;
    wholesalerGlass = false;
    wholesalerMetal = false;
    
    resetModel();
    
  } else if (key == '4') { //Thursday
    currentDay = day.get(3);
    
    //MRF schedule
    pickingPlastic = true;
    pickingPaper = true;
    pickingGlass = true;
    pickingMetal = true;
    
    //W schedule
    wholesalerPlastic = true;
    wholesalerPaper = true;
    wholesalerGlass = true;
    wholesalerMetal = true;
    
    resetModel();
    
  } else if (key == '5') { //Friday
    currentDay = day.get(4);
    
    //MRF schedule
    pickingPlastic = false;
    pickingPaper = true;
    pickingGlass = false;
    pickingMetal = false;
    
    //W schedule
    wholesalerPlastic = false;
    wholesalerPaper = false;
    wholesalerGlass = false;
    wholesalerMetal = false;
    
    resetModel();
    
  } else if (key == '6') { //Saturday
    currentDay = day.get(5);
    
    //MRF schedule
    pickingPlastic = true;
    pickingPaper = true;
    pickingGlass = true;
    pickingMetal = false;
    
    //W schedule
    wholesalerPlastic = false;
    wholesalerPaper = true;
    wholesalerGlass = true;
    wholesalerMetal = false;
    
    resetModel();
    
  } else if (key == '7') {
    currentDay = day.get(6);
  }
  else if (key == 'm'){
    initMRFs();
  }
  else if (key == 'w'){
    initWholesalers();
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
