// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;

import java.util.*;
float laps; 


//  Object to define and capture a specific origin, destiantion, and path
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

//draw a shortest path between the kabadiwala and the source
void kPath() {
  println("kPath is running");
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */

          
    // Searches for valid paths only
    boolean notFound = true;
    
    while(notFound) {

      //1. choose the points for the kabadiwala and for the source
      //2. initialize the Bundle and place it at source location    
          chooseSource();
      //3. identify the path between kabadiwala and source
          Path a = new Path(kabadiwala, source);
        
      //3. solve the path
        a.solve(finder);
            //a.straightPath();
            if(a.waypoints.size() > 1 && a.waypoints.get(a.waypoints.size()-1) == source) {
              //println("path is like ",  a.waypoints.get(a.waypoints.size()-1), source);
              notFound = false;
              paths.add(a);
            }
  } //end 

  println("paths: ", paths.size());
} //end KPaths

      
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
