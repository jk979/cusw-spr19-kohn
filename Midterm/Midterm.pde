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

boolean soldToKabadiwala;

Bundle b;

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
  int numKabadiwalas = 1;
  int numBundlesPerKabadiwala = 2;
  
  //Set special indices <== only wake these people up first 
  //only wake 0, 3 
  
  //Number of groups 
    for(int i = 0 ; i< numKabadiwalas; i++){
        chooseKabadiwala(); //choose the kabadiwala agent from the random list; returns "kabadiwala"
        //initialize 0 for each variable
           roundtripKM = 0;
           totalKPickupCost = 0;
           kabadiwala_pickup_cost_paper = 0;
           kabadiwala_pickup_cost_plastic = 0;
           kabadiwala_pickup_cost_glass = 0;
           kabadiwala_pickup_cost_metal = 0;
           misc = 0;
        
        for(int j = 0; j<numBundlesPerKabadiwala; j++){ //how many bundles one kabadiwala should get
          kPath(); //choose Source; make a path between "kabadiwala" and "source"
          
          PVector sourceLocation = new PVector();
          sourceLocation = chooseSource();
          println("source Location: ",sourceLocation);
          
          b = new Bundle(sourceLocation);
          if(b.pickedUp==true){
            println("i've been picked up.");
          }
          else if(b.pickedUp = false){
            println("i'm not picked up.");
          }
          println("bundle's location is",b.loc);
          println("bundle x is ", b.w);
          println("bundle y is ", b.h);
        }
    }

  println("path size is",paths.size());
  
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
  
  //map extents
  map = new MercatorMap(width_map, height_map, 19.0942, 19.0391, 72.8143, 72.8462, 0); //bandra
  //map = new MercatorMap(width_map, height_map, 19.2729, 19.2322, 72.8309, 72.8989, 0); //dahisar
  //map = new MercatorMap(width_map, height_map, 19.1213, 19.0545, 72.8787, 72.9612, 0); //ghatkopar
  //map = new MercatorMap(width_map+150, height_map, 19.2904, 18.8835,72.7364,73.0570, 0); //mumbai complete
  
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
              
   //euclidean
      //test if agent is alive; agent stops upon returning to shop
  boolean collisionDetection = true;
  for (Agent p: people) {
    if(p.isAlive){
    
    p.update(personLocations(people), collisionDetection);
    p.pathToDraw.display(100, 100); //draw path for agent to follow
    p.display(#FF00FF, 255); //draw agent
    b.display();

    //stroke(color(#FF0000));
    //noFill();
    //polygon(bundle.x, bundle.y, 5, 10);
    }
  
  
   
   //////////////////////////////////////////////////////
   
   //checking where the bundle is. Is it with the agent? Is it at the origin?
   //is the bundle at the source?
   //is the bundle at the kabadiwala?
   //is the bundle with the agent?
   //initial conditions: bundle at source, agent in transit
   euclideanAgentBundle = parseInt(dist(b.w, b.h, p.location.x, p.location.y));
   euclideanOriginBundle = parseInt(dist(b.w, b.h, kabadiwala.x, kabadiwala.y));
   euclideanAgentSource = parseInt(dist(p.location.x, p.location.y, source.x, source.y));
   euclideanAgentOrigin = parseInt(dist(p.location.x, p.location.y, kabadiwala.x, kabadiwala.y));
   
   if(euclideanAgentBundle < 4){ //1. agent arrives at source and gets bundle
     b.w = p.location.x; 
     b.h = p.location.y;
     b.pickedUp = true;
     b.timesCollected = 1;
     
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
     b.w = kabadiwala.x; 
     b.w = kabadiwala.y;
     b.pickedUp = false;
     b.timesCollected++;
     
     //chooseSource();
     //kPath();
  
     laps = laps + 0.5; //laps increasedis
     //add up bundles collected
     //bundlesCollected = 1;
     
     println("reached origin! laps = ", laps);
     //when laps = 1, exit the loop
     if(b.timesCollected == 1){
       println("i completed roundtrip!");
       b.pickedUp = false;
     }
     
     //checks where the bundle is
     /*
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
      */


     
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
      kabadiwala_pickup_cost_paper = paperKBuy * wt_paper;
      kabadiwala_pickup_cost_plastic = plasticKBuy * wt_plastic;
      kabadiwala_pickup_cost_glass = glassKBuy * wt_glass;
      kabadiwala_pickup_cost_metal = metalKBuy * wt_metal;
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
  text("Inputs",600,180);
  fill(255,255,255);
  //draw input content
  textSize(12);
  text("# kabadiwalas: "+numKabadiwalas,525,220);
  text("# bundles per kabadiwala: "+numBundlesPerKabadiwala,525,240);
  //quantities
  text("---------Quantities-------------------", 525,260);
  text("Paper: "+ wt_paper + " KG",525,280);
  text("Plastic : " + wt_plastic + " KG",525,300);
  text("Glass: " + wt_glass + " KG",525,320);
  text("Metal: " + wt_metal + " KG",525,340);
  text("----------Buying Prices---------------", 525,360);
  //buying prices
  text("Paper Sale Price to Kabadiwala: "+paperKBuy + " INR",525,380);
  text("Plastic Sale Price to Kabadiwala: "+plasticKBuy + " INR",525,400);
  text("Glass Sale Price to Kabadiwala: "+glassKBuy + " INR",525,420);
  text("Metal Sale Price to Kabadiwala: "+metalKBuy + " INR",525,440);
  //selling prices
  //total cost of buying
  text("----Kabadiwala Total Cost of Buying---", 525,460);
  text("Paper: "+kabadiwala_pickup_cost_paper,525,480);
  text("Plastic: "+kabadiwala_pickup_cost_plastic,525,500);
  text("Glass: "+kabadiwala_pickup_cost_glass,525,520);
  text("Metal: "+kabadiwala_pickup_cost_metal,525,540);
  text("Miscellaneous Items: "+ misc + " INR",525,560);


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
  text("---------Bundle Status----------------", 925,260);
  text("bundle times collected: "+b.timesCollected,925,280);
  text("bundle is picked up? "+b.pickedUp,925,300);
  text("---------Wholesalers----------------", 925,320);
  
  
  
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
