// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;
boolean pathNotFound; //pathNotFound is a global variable
Bundle b;

import java.util.*;
float laps; 

//  Object to define and capture a specific origin, destination, and path
ArrayList<Path> paths = new ArrayList<Path>();

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
void kPath() {
  
  println("kPath is running");
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  println("initialized finder");

  // Searches for valid paths only
  pathNotFound = true;    
  
  while(pathNotFound) {
    //identify the path between kabadiwala and source
    Path a = new Path(kabadiwala, source);
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
         println("No valid path found, resetting source" , kabadiwala, source);
         chooseSource();
        }
     }
  } //end while notFound
  println("paths: ", paths.size());
} //end KPaths

 void makeCompletePathFromKabadiwala(){
   //initialize path
   paths = new ArrayList<Path>();
   
   println("now choosing source...");
   chooseSource(); //returns source
   
   //initialize kPath
   kPath();
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
     b = new Bundle(sourceLocation);
     
 }
 }


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

void initPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  people = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    int random_index = int(random(paths.size()));
    Path random_path = paths.get(random_index);
    if (random_path.waypoints.size() > 1) {
      int random_waypoint = 0;//int(random(random_path.waypoints.size()));
      //float random_speed = random(0.1, 0.3);
      float random_speed = 0.7;
      PVector loc = random_path.waypoints.get(random_waypoint);
      Agent person = new Agent(loc.x, loc.y, 7, random_speed, random_path.waypoints);
      person.id = people.size();
      people.add(person);
      person.pathToDraw = random_path;
      //Only call the first person of each group to life 
      if(people.size() == 1 || people.size() == 1) person.isAlive = true;
      else person.isAlive= false;
    }
    
  }
  println("People in system: ", people.size());
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
    p.display(#FF00FF, 255); //draw agent
    b.display(); //draw bundle
    }
   
   //checking where the bundle is. Is it with the agent? Is it at the origin?
   
   //initial conditions: bundle at source, agent in transit
   int euclideanAgentBundle = parseInt(dist(b.w, b.h, p.location.x, p.location.y));
   int euclideanOriginBundle = parseInt(dist(b.w, b.h, kabadiwala.x, kabadiwala.y));
   int euclideanAgentSource = parseInt(dist(p.location.x, p.location.y, source.x, source.y));
   int euclideanAgentOrigin = parseInt(dist(p.location.x, p.location.y, kabadiwala.x, kabadiwala.y));
   
   //1. when agent encounters bundle
   if(euclideanAgentBundle < 4){ 
     b.w = p.location.x; 
     b.h = p.location.y;
     b.pickedUp = true;
     b.timesCollected = 1;
     soldToKabadiwala = true;
   }
   
   //2. bundle brought to kabadiwala
   if(euclideanOriginBundle < 3){ 
     println("bundle brought to kabadiwala");
     b.w = kabadiwala.x; 
     b.w = kabadiwala.y;
     b.pickedUp = false;
     
     println("the bundle #" +b.id+" has been touched by a collector " +b.timesCollected+" times");
     //try making each bundle and material have an ID:{times collected, picked Up, location, etc} value
     
     b.timesCollected++;
     roundtripKM = parseInt((2*HavD)/1000);           


    roundtripCompleted = true;

    if(roundtripCompleted == true){
            //KILL THE AGENT
            p.isAlive = false;
            println("killed person");
            //if there are more iterations to go, resurrect an agent
            println("j in this roudntrip is",j);
            if(j<numBundlesPerKabadiwala){
              println("j vs num", j);
              println("bpk",numBundlesPerKabadiwala);
              people.get(p.id+1).isAlive = true;
              println("resurrected agent");
            }
   }
   }
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
