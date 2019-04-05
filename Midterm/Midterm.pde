//midterm assignment


/*
Bugs left: 
initModel -- is the ways network changing? Do you have to re-chose any data structures?
while loop exit condition/choosing -- are there options that shouldn't be chosen together, etc? 
*/

//bundles and source must be linked

//Background 

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

//checks where the bundle is
boolean bundleAtKabadiwala;
boolean bundleWithAgent;
boolean bundleAtSource;

boolean soldToKabadiwala;


///////////////////////

//set up GUI
String title = "Kabadiwala Simulation";
String project = "Description here";

//scrollbars (horizontal and vertical)

boolean showUI = true;

/////////////////////////

//contain the model initialization
void initModel(){
  addDays();
  soldToKabadiwala = false;
  //1. initialize the network using one of these methods
  //randomNetwork(0.5);
  waysNetwork(ways);
  //randomNetworkMinusBuildings(0.1, polygons);
  paths = new ArrayList<Path>();
  
  //2. initialize origin/destination and paths for kabadiwalas using kPath() method
  int numGroups = 1;
  int numPairings = 1;
  
  //Set special indices <== only wake these people up first 
  //only wake 0, 3 
  
  //Number of groups 
    for(int i = 0 ; i< numGroups; i++){
        chooseKabadiwala(); //get the shared origin for each group 
        for(int j = 0; j<numPairings; j++){
          kPath();
        }
    }

  println(paths.size());

  //kPath();
  
  ////3. initialize population

  initPopulation(paths.size());
  
  
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
  //parseOSMNX();
  //parseDataMumbai();
  
  //load map and data for all of mumbai
  //map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0);
  //parseDataMumbai();
  
  pg.beginDraw();
  pg.background(0);
  drawGISObjects(); //make this into PGraphic
  pg.endDraw();
  
  //initialize model and simulation
  initModel();
  

}

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

  drawBlock();
  
  
    //5. display the yellow circle signifying the bundle of materials
     //display bundle location
              
   //euclidean
      //test if agent is alive; agent stops upon returning to shop
  boolean collisionDetection = true;
  for (Agent p: people) {
    if(p.isAlive){
    p.update(personLocations(people), collisionDetection);
    p.display(#FFFFFF, 255);
    p.pathToDraw.display(100, 100);
    
    stroke(color(#FF0000));
    noFill();
    polygon(bundle.x, bundle.y, 3, 4);
    }
  
  //initialize 0 for each variable
   roundtripKM = 0;
   totalKPickupCost = 0;
   kabadiwala_pickup_cost_paper = 0;
   kabadiwala_pickup_cost_plastic = 0;
   kabadiwala_pickup_cost_glass = 0;
   kabadiwala_pickup_cost_metal = 0;
   misc = 0;
   
   //////////////////////////////////////////////////////
   
   //checking where the bundle is. Is it with the agent? Is it at the origin?
   //is the bundle at the source?
   //is the bundle at the kabadiwala?
   //is the bundle with the agent?
   //initial conditions: bundle at source, agent in transit
   euclideanAgentBundle = parseInt(dist(bundle.x, bundle.y, p.location.x, p.location.y));
   euclideanOriginBundle = parseInt(dist(bundle.x, bundle.y, kabadiwala.x, kabadiwala.y));
   euclideanAgentSource = parseInt(dist(p.location.x, p.location.y, source.x, source.y));
   euclideanAgentOrigin = parseInt(dist(p.location.x, p.location.y, kabadiwala.x, kabadiwala.y));
   
   if(euclideanAgentBundle < 4){ //1. agent arrives at source and gets bundle
     println("now carrying bundle!");
     bundle.x = p.location.x; 
     bundle.y = p.location.y;
     bundleWithAgent = true;
     
     int collisionSource; 
     if(euclideanAgentSource < 4){ //lap is logged
       collisionSource = 1;
       if(collisionSource == 1){ //only count the lap if it's run into the source once
         laps = laps + 0.5; //first time is 0.5
         println("laps: ",laps);
       }
       else if(collisionSource>=1){ //in case it runs into the source again by accident, make sure laps stays at 0.5
         laps = 0.5;
         println("adding half a lap now...", laps);
       }
       collisionSource++;
       soldToKabadiwala = true;
     }
   }
   
   if(euclideanOriginBundle < 2){ //bundle brought to kabadiwala
     println("bundle brought to kabadiwala");
     bundle.x = kabadiwala.x; 
     bundle.y = kabadiwala.y;
     bundleAtKabadiwala = true;
  
     laps = laps + 0.5; //laps increase
     //add up bundles collected
     bundlesCollected = 1;
     
     println("reached origin! laps = ", laps);
     //when laps = 1, exit the loop
     if(laps == 1){
       println("i completed roundtrip!");
     }
     
     //checks where the bundle is
     if(bundleWithAgent == false) {
        println("i don't have a bundle yet.");
        println("i'm on lap ",laps);
      }
      
      if(bundleWithAgent == true){
      //6. is the bundle's position the same as the origin? 
      //if yes, advance bundleCount and leave the bundle there
      //check if bundle_released = true, means it's deposited the bundle
        println("i grabbed the bundle");
        println("and i'm on lap ", laps);
        
      }


     
      //KILL THE AGENT
      p.isAlive = true;
      //people.get(p.id+1).isAlive = true;
      
      //catch(Exception e){}
      //add up the km traveled roundtrip
      roundtripKM = parseInt((2*HavD)/1000);
      //reset the lap count
      laps = 0;
   }
  
      
    }

    //when wholesaler picks up, revenue is earned!
    //kabadiwala_offload_cost_paper = paperKSell*paperQuantity;
    //paperWBuy = paperKSell;
  
    
    if (soldToKabadiwala == true){
      //bundle picked up and transaction made
      kabadiwala_pickup_cost_paper = paperKBuy*paperQuantity;
      kabadiwala_pickup_cost_plastic = plasticKBuy*plasticQuantity;
      kabadiwala_pickup_cost_glass = glassKBuy*glassQuantity;
      kabadiwala_pickup_cost_metal = metalKBuy*metalQuantity;
      misc = 3000;
      totalKPickupCost = (kabadiwala_pickup_cost_paper+kabadiwala_pickup_cost_plastic+kabadiwala_pickup_cost_glass+kabadiwala_pickup_cost_metal+misc);
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
  text("The Kabadiwala's Journey", 540, 50);
  //draw description
  fill(240,240,240);
  textSize(12);
  text("Kabadiwalas are the informal recycling heroes of Mumbai, India. \nThey collect recyclable plastic, paper, glass, and metal from households and sell it up the value chain.",540,70);
  text("This map shows kabadiwalas between their shop (red) and the source of material (yellow). \n Bundle of Materials: red circle",540,110);
  text("By Jacob Kohn", 1100,50);
  //draw input box
  fill(bgColor, 2*baseAlpha);
  rect(520, 150, 300, 500, 10);
  //draw input title
  textSize(16);
  rect(520,150,300,50,10);
  fill(139,0,0);
  text("Inputs (Weekly Average)",580,180);
  fill(255,255,255);
  //draw input content
  textSize(12);
  //quantities
  text("Paper Quantity: "+ paperQuantity + " KG",525,220);
  text("Plastic Quantity: " + plasticQuantity + " KG",525,240);
  text("Glass Quantity: " + glassQuantity + " KG",525,260);
  text("Metal Quantity: " + metalQuantity + " KG",525,280);
  text("--------------------------------------", 525,300);
  //buying prices
  text("Paper Sale Price to Kabadiwala: "+paperKBuy + " INR",525,320);
  text("Plastic Sale Price to Kabadiwala: "+plasticKBuy + " INR",525,340);
  text("Glass Sale Price to Kabadiwala: "+glassKBuy + " INR",525,360);
  text("Metal Sale Price to Kabadiwala: "+metalKBuy + " INR",525,380);
  //selling prices
  //total cost of buying
  text("--------------------------------------", 525,400);
  text("Kabadiwala's Total Cost of Buying:",525,420);
  text("Paper: "+kabadiwala_pickup_cost_paper,525,440);
  text("Plastic: "+kabadiwala_pickup_cost_plastic,525,460);
  text("Glass: "+kabadiwala_pickup_cost_glass,525,480);
  text("Metal: "+kabadiwala_pickup_cost_metal,525,500);
  text("Miscellaneous Items: "+ misc + " INR",525,520);


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
  text("Kabadiwala's Gross Profit: "+ (kabadiwala_offload_cost_paper - totalKPickupCost)+ " INR",925,220);
  text("Kabadiwala's Roundtrip Distance: "+ roundtripKM + " KM", 925, 240);
  
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
}

void keyPressed(){
    if(key==ENTER || key==RETURN){
      initModel();
  }
  else if(key=='1'){
    text("Day: "+day.get(0), 1100, 70);
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
