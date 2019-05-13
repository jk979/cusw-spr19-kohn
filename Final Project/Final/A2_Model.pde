// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;
boolean pathNotFound; //pathNotFound is a global variable

import java.util.*;
float laps; 


//  Objects to define agents that navigate our environment
ArrayList<Agent> people = new ArrayList<Agent>();

//ways network using roads as ways
void waysNetwork(ArrayList<Way> w) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution, w);
}

//draw a shortest path between the kabadiwala and the source; Path defined by two coordinates "origin" and "destination"

/*
void kPath() {
  /*  An pathfinder object used to derive the shortest path. */
  //finder = new Pathfinder(network);
  //println("initialized finder");

  // Searches for valid paths only
  //pathNotFound = true;    
  
  /*
  while(pathNotFound) {
    //identify the path between kabadiwala and source
    Path a = new Path(kabadiwala_loc, source);
     if(HavD<=3500){ //solve the path only if HavD<=3km
        a.solve(finder);
        //println(a.waypoints.size());
        //a.straightPath();
        if(a.waypoints.size() > 1 && a.waypoints.get(a.waypoints.size()-1) == source) {
          println("found valid path!");
          pathNotFound = false;
          paths.add(a);
        }
        else{
          //are you resetting your source, etc? 
         println("No valid path found, resetting source" , kabadiwala_loc, source);
         //chooseSource();
        }
     }
  } //end while notFound
  println("paths: ", paths.size());
}
*/ //end KPaths 

/*
 void makeCompletePathFromKabadiwala(){
   //initialize path
   paths = new ArrayList<Path>();
   
   println("now choosing source...");
   //chooseSource(); //returns source
   
   //initialize kPath
   //kPath();
   println("drawing path now");
   //within kPath, use kabadiwala and source
   //choose source
   //if no valid path, reset the source and repeat kPath
   
   if(pathNotFound == false){
     //if valid path, make sourceLocation the chooseSource()
     PVector sourceLocation = new PVector();
     sourceLocation = source;
     //sourceLocation = temp; //returns source
     println("Source Location: ",sourceLocation);
     
     //initialize bundle at sourceLocation
     
 }
 }
 */


//draws a path that hits 10 kabadiwalas using the shortest distance between them and the Wholesaler/MRF
void WholesalerPath(){ 
//option 1. wholesaler is picking up
//origin = wholesaler point on map

//option 2. MRF is picking up
//origin = MRF point on map

//from the list of kabadiwalas, divide them into groups of 3
//for each group: 
//check if all of them have bundles in their shops
//get the shortest distance linking all of them with Wholesaler point as origin and destination
//run the path using an agent and pick up all the materials
//stop when you reach the Wholesaler point again

}

void initPopulation(int kabadiwalaNum) {
  //  Object to define and capture a specific origin, destination, and path
  ArrayList<Path> paths = new ArrayList<Path>();
  
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  //1. make an arraylist of people 
  people = new ArrayList<Agent>();
  
  //2. for each bundle...
  for (int i=0; i<3; i++) {

    //3. get the ID to find the unique path
    String composite_ID = str(kabadiwalaNum)+"-"+str(i+1);  //gets composite ID of 1-1, 1-2, etc. 
    println("composite ID is now",composite_ID);
    
    //4. get path to bundle for that unique composite_ID
    ArrayList<PVector> temp_array = newMergedMap.get(composite_ID);
    println("getting path array for composite ID ",composite_ID);
    
    //5. get last point in array
    PVector bundlepoint = temp_array.get(temp_array.size()-1);
    
    //6. assign bundle to last point and translate to map coordinates
    b = new Bundle(map.getScreenLocation(bundlepoint));
    b.id = composite_ID; //bind to ID
  
    //7. add to bundleArray for displaying in draw()
    bundleArray.add(b);
    
    //8. add current path to list of paths
    Path c = new Path(kabadiwala_loc, b.loc, temp_array, true);
    paths.add(c); //added the single bundle path to this bundle
    
  } //repeat for each path
  
  //9. once paths has been populated with all the paths for the Agent...
  println("number of paths in pathArray is: ",paths.size());
    
  //10. add agent to the path if the path has been parsed successfully
  if (paths.get(0).waypoints.size() > 1) { 
    //float random_speed = random(0.1, 0.3);
    float random_speed = 0.7;
    //println("making a waypoints pvector to get the full waypoints path for this bundle");
    PVector loc = paths.get(0).waypoints.get(0); //get the full waypoints path
    
    //make an agent with the desired features, and the agent is associated with that bundle_path
    Agent person = new Agent(loc.x, loc.y, 7, random_speed, paths);
    //person.id = i+1; //make the person's id "1" if it's the first path, "2" if it's the second path, etc)
    people.add(person);

    person.pathToDraw = paths.get(0);
    if(people.size() == 1 || people.size() == 1) person.isAlive = true;
    else person.isAlive= false;
  }
}

ArrayList<PVector> personLocations(ArrayList<Agent> people) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: people) {
    l.add(a.location);
  }
  return l;
}

void checkAgentBehavior(){
   //euclidean
      //test if agent is alive; agent stops upon returning to shop
  boolean collisionDetection = true;
  for (Agent p: people) {
    if(p.isAlive){
    
    p.update(personLocations(people), collisionDetection);
    p.pathToDraw.display(100, 100); //draw path for agent to follow
    p.display(); //draw agent
    b.display(); //draw bundle
    }
   
   /*
   
   //checking where the bundle is. Is it with the agent? Is it at the origin?
   
   //initial conditions: bundle at source, agent in transit
   int euclideanAgentBundle = parseInt(dist(b.w, b.h, p.location.x, p.location.y));
   int euclideanOriginBundle = parseInt(dist(b.w, b.h, kabadiwala_loc.x, kabadiwala_loc.y));
   int euclideanAgentSource = parseInt(dist(p.location.x, p.location.y, source.x, source.y));
   int euclideanAgentOrigin = parseInt(dist(p.location.x, p.location.y, kabadiwala_loc.x, kabadiwala_loc.y));
   
   //1. when agent encounters bundle
   if(euclideanAgentBundle < 4){ 
     //println("the agent encountered the bundle and picked it up!");
     b.w = p.location.x; 
     b.h = p.location.y;
     b.pickedUp = true;
     b.timesCollected = 1;
     soldToKabadiwala = true;
   }
   
   //2. bundle brought to kabadiwala
   if(euclideanOriginBundle < 3){ 
     //println("bundle brought to kabadiwala shop");
     b.w = kabadiwala_loc.x; 
     b.h = kabadiwala_loc.y;
     b.pickedUp = false;
     
     //println("the bundle #" +b.id+" has been touched by collector "+b.timesCollected+" times");
     //try making each bundle and material have an ID:{times collected, picked Up, location, etc} value
     
     b.timesCollected++;
     //roundtripKM = //total distance of the path
     
    roundtripCompleted = true;

    if(roundtripCompleted == true){
      p.isAlive = false;
      println("HERE I AM COMPLETED");
      //make a new path
      p.isAlive = true;
      tempModel();
    }
   }
   */
  }
}

    
void checkSaleBehavior(){
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
}}
