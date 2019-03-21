//midterm assignment

//done: base map and kabadiwala points
//to do: agent movements between kabadiwala points and random sources + kabadiwala and mrf

//Background 

//make Bandra map
MercatorMap map; 
PImage background;
PGraphics pg;

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
  //randomNetwork(0.5);
  waysNetwork(ways);
  //randomNetworkMinusBuildings(0.1, polygons);
  
  //initialize origin and destinations
  //choose random kabadiwala
  chooseRandomKabadiwala();
  //make all kabadiwalas
  //chooseAllKabadiwalas();
  
  //draw random source for kabadiwala
  chooseRandomSource();
  
  //2. initialize paths using one of these methods
  //randomPaths(3);
  //poiPaths(1);
  kPath();
  
  //3. initialize population
  //initPopulation(30*paths.size());
  initPopulation(1*paths.size());
  
  
}

void setup(){
  size(1250,750); //add ,P3D to make it 3D
  //createGraphics(x, y, width, height);
  pg = createGraphics(width, height);
  
  //initialize data structures
  
  
  //draw the map with given dimensions
  int width_map = 450;
  int height_map = height;
  
  //first, load the base data
  loadData();
  
  //initialize attributes
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  pois = new ArrayList<POI>();
  
  //load map and data for bandra only
  map = new MercatorMap(width_map, height_map, 19.0942, 19.0391, 72.8143, 72.8462, 0);
  parseData();
  
  
  //load map and data for all of mumbai
  //map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0);
  //parseDataMumbai();
  
  pg.beginDraw();
  pg.background(0);
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  
  //initialize model and simulation
  initModel();
  
  
  /*
  hs = new HScrollbar(width - int(height*MARGIN) - int(0.3*height), int((1-1.5*MARGIN)*height), int(0.3*height), int(MARGIN*height), 5);
  camRotation = hs.getPosPI(); // (0 - 2*PI)
  */
  
}

void draw(){
  
  //camera(70.0,-35.0, 1200.0, 450.0, -50, 0, 0, 1, 0);
  background(0);
  image(pg, 0,0);
 
  //draw mrfs
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
 
  //draw kabadiwalas
  for(int i=0; i<kData.getRowCount()-1; i++){
     k_array.get(i).draw();
  }
 
 //draw path here...
   //draw path
  for (Path b: paths) {
    b.display(100,100);
  }
 
  //displayAllKabadiwala();

  displayBundle();
  
  
  boolean collisionDetection = true;
  for (Agent p: people) {
    if(p.isAlive){
    p.update(personLocations(people), collisionDetection);
    p.display(#FFFFFF, 255);
    }
  
  //test pickup of bundle of materials
   euclideanAgentBundle = parseInt(dist(bundle.x, bundle.y, p.location.x, p.location.y));
   roundtripKM = 0;
    if (euclideanAgentBundle < (2) ) {
      //bundle position = Agent position
      bundle.x = p.location.x; 
      bundle.y = p.location.y;
      kabadiwala_pickup_cost_paper = paperKBuy*paperQuantity;
      kabadiwala_pickup_cost_plastic = plasticKBuy*plasticQuantity;
    }
    
    //if it's on the second lap and it's next to the origin
    euclideanOriginBundle = parseInt(dist(bundle.x, bundle.y, randomKabadiwala.x, randomKabadiwala.y));
    if(laps>=2 && euclideanOriginBundle < (4)){
      //drop off the bundle
      bundle.x = randomKabadiwala.x;
      bundle.y = randomKabadiwala.y;
      //KILL THE AGENT
      p.isAlive = false;
      roundtripKM = parseInt((2*HavD)/1000);
    }

//when wholesaler picks up, revenue is earned!
//kabadiwala_offload_cost_paper = paperKSell*paperQuantity;
//paperWBuy = paperKSell;
  }
  
  text(frameRate, 25, 25);
  
  //draw title box
  int bgColor = 230;
  noStroke();
  fill(bgColor, 2*baseAlpha);
  rect(520,20,700,120,10);
  //draw title text
  fill(255,255,255);
  textSize(24);
  text("The Kabadiwala's Journey", 540, 60);
  //draw description
  fill(240,240,240);
  textSize(12);
  text("This map shows kabadiwalas moving back and forth between their shop (green) and the source of material (red). \nPress SPACE to begin the work week!",540,100);

  //draw input box
  fill(bgColor, 2*baseAlpha);
  rect(520, 150, 300, 500, 10);
  //draw input title
  textSize(16);
  rect(520,150,300,50,10);
  fill(139,0,0);
  text("Inputs",640,180);
  fill(255,255,255);
  //draw input content
  textSize(12);
  text("Paper Quantity: "+ paperQuantity + " KG",525,220);
  text("Paper Sale Price to Kabadiwala: "+paperKBuy + " INR",525,240);
  text("Kabadiwala's Total Cost of Buying Paper: "+kabadiwala_pickup_cost_paper,525,260);
  text("--------------------------------------", 525,280);
  text("Plastic Quantity: " + plasticQuantity + " KG",525,300);
  text("Plastic Sale Price to Kabadiwala: "+plasticKBuy + " INR",525,320);
  text("Kabadiwala's Total Cost of Buying Paper: "+kabadiwala_pickup_cost_plastic,525,340);
  text("--------------------------------------", 525,360);
  text("Glass Quantity: " + glassQuantity + " KG",525,380);
  text("Glass Sale Price to Kabadiwala: "+glassKBuy + " INR",525,400);
  text("Kabadiwala's Total Cost of Buying Glass: "+kabadiwala_pickup_cost_glass,525,420);
  text("--------------------------------------", 525,440);
  text("Glass Quantity: " + metalQuantity + " KG",525,460);
  text("Glass Sale Price to Kabadiwala: "+metalKBuy + " INR",525,480);
  text("Kabadiwala's Total Cost of Buying Glass: "+kabadiwala_pickup_cost_metal,525,500);
  
  //draw output box
  fill(bgColor, 2*baseAlpha);
  rect(920, 150, 300, 500, 10);
  //draw output title
  textSize(16);
  rect(920,150,300,50,10);
  fill(0,100,0);
  text("Outputs",1040,180);
  //draw output content
  fill(255,255,255);
  textSize(12);
  text("Kabadiwala's Gross Profit: "+ (kabadiwala_offload_cost_paper - kabadiwala_pickup_cost_paper)+ " INR",925,220);
  text("Kabadiwala's Roundtrip Distance: "+ roundtripKM + " KM", 925, 240);
  
  //noLoop();
}

void keyPressed(){
  initModel();
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
- simplify your code, take out what you don't need
- convert OSMNX simplified road network to a GeoJSON and add it here
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
