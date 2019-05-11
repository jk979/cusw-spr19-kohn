//bundles and source must be linked

//make Bandra map
MercatorMap map; 
String whichBackground;
int k_min = 0;
int k_max = 162;
int m_min = 0;
int m_max = 39;
int w_min = 0;
int w_max = 3;

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
void initModel() {
  soldToKabadiwala = false;

  //println("NOT initializing ways network"); //because the paths along the network are already chosen
  //waysNetwork(ways); //initialize the Ways network (roads)

  println("entering group for loop");
  
  //1. Set up the number of kabadiwalas
  for (int i = k_min; i<k_max; i++) {
    //println("going from ",k_min," to ",k_max);
    chooseKabadiwala(i); //choose the #i kabadiwala agent
    //initialize the agent on screen

    //initialize 0 for each variable
    roundtripKM = 0;
    totalKPickupCost = 0;
    kabadiwala_pickup_cost_paper = 0;
    kabadiwala_pickup_cost_plastic = 0;
    kabadiwala_pickup_cost_glass = 0;
    kabadiwala_pickup_cost_metal = 0;
    misc = 0;

    //2. For each kabadiwala, set up each kabadiwala's bundles
    println("setting up "+numBundlesPerKabadiwala+" bundles for kabadiwala "+str(i));
    for (int j = 0; j<numBundlesPerKabadiwala; j++) { //how many bundles one kabadiwala should get
    println("2. now getting bundle #"+j+" for this kabadiwala");
      roundtripCompleted = false;
      if(roundtripCompleted == false){
        
        String composite_ID = str(i+1)+"-"+str(j+1);  
        
        //2a. get path to bundle
        ArrayList<PVector> temp_array = newMergedMap.get(composite_ID);
        ArrayList<PVector> mrf_test_array = MRFMergedMap.get("HW17-sector1");
        println("PRINTING MRF TEST ARRAY",mrf_test_array);
        println("3. getting path array for composite id",composite_ID);
        
        //2b. get last point in array
        PVector bundlepoint = temp_array.get(temp_array.size()-1);
        //println("bundlepoint located at the endpoint for ",composite_ID, " which is ",bundlepoint);
  
        //3. assign bundle to last point and translate to map coordinates
        b = new Bundle(map.getScreenLocation(bundlepoint));
        b.id = composite_ID; //bind to ID
  
        //  //add to bundleArray for displaying in draw()
        bundleArray.add(b);
  
        ArrayList<PVector> myVectors = newMergedMap.get(composite_ID);
  
        Path a = new Path(kabadiwala_loc, b.loc, myVectors, true);
        paths.add(a); //added the single bundle path to this bundle
        println("4. path made, now initializing population...");
        initPopulation(1); // 2
        } //end roundtripCompleted = false
    }
    //once all the bundle paths are added to Paths...
    //agent walks on each path in paths

  }

  //set up Level 2

  for (int i = m_min; i<m_max; i++) {
    chooseMRF(i);
    MRFAgent m = new MRFAgent(mrf_loc.x, mrf_loc.y);
    mrfArray.add(m);
  }
  for (int i = w_min; i<w_max; i++) {
    chooseWholesaler(i);
    WholesalerAgent w = new WholesalerAgent(w_loc.x, w_loc.y);
    wholesalerArray.add(w);
  }
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

  // TEMPORARY MOVING TO HW //
  width_map = 450;
  scalarForMap_a = 19.0942; 
  scalarForMap_b = 19.0391;
  scalarForMap_c = 72.8143;
  scalarForMap_d = 72.8462;
  setMap();
    
  //set number of actors for HW
  k_min = 0; 
  k_max = numKabadiwalas; //testing one at a time
  m_min = 16;
  m_max = 18;
  w_min = 1;
  w_max = 2;
  
    // END TEMPORARY HW MAP //

  //set the world map
  setMap();
  
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

  //level 2 paths: kabadiwala --> MRF
  loadKabadiwalaToMRF();
  parseKabadiwalaToMRF();

  loadWardBoundaries();
  parseWardBoundaries();
  loadRailways();
  parseRailways();

  //initialize model and simulation
  println("initializing model...");
  initModel();

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
  for (int i = 0; i<kabadiwalaArray.size(); i++) {
    KabadiwalaAgent k = (KabadiwalaAgent) kabadiwalaArray.get(i);
    k.display();
  }

  //draw the MRF agent!
  //for (int i = 0; i<mrfArray.size(); i++) {
  //  MRFAgent m = (MRFAgent) mrfArray.get(i);
  //  m.display();
  //}

  //draw the wholesaler!
  //for (int i = 0; i<wholesalerArray.size(); i++) {
  //  WholesalerAgent w = (WholesalerAgent) wholesalerArray.get(i);
  //  w.display();
  //}
}

void draw() {
  //includes drawing background, MRFs, kabadiwalas, path, bundle of materials, agents, testing if the agent has reached or dropped off the bundle, and wholesalers

  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  background(0);
  image(pg, 0, 0);

  drawShops();
  drawBundles();

  //draw each of the poi_hh
  /*
  for(int i = 0; i<poi_hh_array.size(); i++){
   poi_hh_array.get(i).draw();
   }
   */

  //println("now checking agent behavior...");
  checkAgentBehavior();
  checkSaleBehavior();

  drawAgents();
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

void keyPressed() {
  if (key==ENTER || key==RETURN) {
    initModel();
  } else if (key=='q') {
    square = !square;
  } else if (key=='z') {     //redraw the GIS objects to HW
  
    background(0);
    width_map = 450;
    scalarForMap_a = 19.0942; 
    scalarForMap_b = 19.0391;
    scalarForMap_c = 72.8143;
    scalarForMap_d = 72.8462;
    setMap();
    
    //set number of actors for HW
    k_min = 0; 
    k_max = numKabadiwalas; //testing one at a time
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
    drawShops();
    drawBundles();
    drawAgents();
    initModel();
    
  } else if (key=='x') {    //redraw the GIS objects to RN

    background(0);
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
    
    initModel();
   
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");
    drawShops();
    drawBundles();
    drawAgents();
    
  } else if (key=='c') {    //redraw the GIS objects to N

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
    k_max = 112;
    m_min = 36;
    m_max = 37;
    w_min = 0;
    w_max = 1;
    
    initModel();
   
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");
    drawShops();
    drawBundles();
    drawAgents();
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
    k_max = 162;
    m_min = 0;
    m_max = 39;
    w_min = 0;
    w_max = 3;
    
    initModel();
   
    pg.beginDraw();
    pg.background(0);
    drawGISObjects(); //make this into PGraphic
    pg.endDraw();
    println("ended drawing new gis objects");
    drawShops();
    drawBundles();
    drawAgents();
  }
}

void keyTyped() {
  if (key == '1') {
    currentDay = day.get(0);
  } else if (key == '2') {
    currentDay = day.get(1);
  } else if (key == '3') {
    currentDay = day.get(2);
  } else if (key == '4') {
    currentDay = day.get(3);
  } else if (key == '5') {
    currentDay = day.get(4);
  } else if (key == '6') {
    currentDay = day.get(5);
  } else if (key == '7') {
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
