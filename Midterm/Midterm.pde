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
  pg = createGraphics(40,40);
  
  //initialize data structures
  
  
  //draw the map with given dimensions
  int width_map = 450;
  int height_map = height;
  
  pushMatrix();
  //bandra only
  //map = new MercatorMap(width_map, height_map, 19.0942, 19.0391, 72.8143, 72.8462, 0);
  
  //mumbai
  map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0);
  popMatrix();
  
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  pois = new ArrayList<POI>();
  
  //load and parse data in setup
  loadData();
  //parseData(); //bandra
  parseDataMumbai();
  
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
  
  pg.beginDraw();
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  image(pg, 50,50);
  //try to get framerate to 60, don't do calculations every frame
  
 
  //draw mrfs
  for(int i=0; i<mrfData.getRowCount()-1; i++){
     mrf_array.get(i).draw();
  }
 
  //draw kabadiwalas
  for(int i=0; i<kData.getRowCount()-1; i++){
     k_array.get(i).draw();
  }
  
 
  //draw path
  for (Path p: paths) {
    p.display(100,100);
  }
  
  
  displayKabadiwala();
  //displayAllKabadiwala();
  displaySource();
  displayPaper();
  
  
  boolean collisionDetection = true;
  for (Agent p: people) {
    p.update(personLocations(people), collisionDetection);
    p.display(#FFFFFF, 255);
  
  //test pickup of garbage
   euclidean = parseInt(dist(paper.x, paper.y, p.location.x, p.location.y));
    if (euclidean < (5) ) {
      //paper position = Agent position
      paper.x = p.location.x; 
      paper.y = p.location.y;
    }
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
  textSize(16);
  fill(bgColor, 2*baseAlpha);
  rect(520, 150, 300, 500, 10);
  //draw input title
  rect(520,150,300,50,10);
  fill(139,0,0);
  text("Inputs",640,180);
  
  //draw output box
  fill(bgColor, 2*baseAlpha);
  rect(920, 150, 300, 500, 10);
  //draw outputs
  rect(920,150,300,50,10);
  fill(0,100,0);
  text("Outputs",1040,180);
  
  
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
Each Agent gets 1 randomly generated Garbage to pick up. ***DONE***
1. Generate the 1 garbage along node-edge network for each agent. ***DONE***
for each agent: 
- find shortest path between agent and garbage ***DONE***
- move on that path to the garbage ***DONE***
-----------------------------------
- when collision detection between agent and garbage, garbage location = agent location - some radius
- after collision detection, agent receives Rupees and reverses path
- when collision detection between agent and shop, agent prints "Collected!"
- profit++;
-----------------------------------
- measure total distance traveled
-----------------------------------
- limit appearance of Sources to less than 2km network distance in any direction from the kabadiwala
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
