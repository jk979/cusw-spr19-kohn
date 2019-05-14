// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Pathfinder finder;
boolean pathNotFound; //pathNotFound is a global variable

import java.util.*;
float laps; 

float totalTripDistanceForKabadiwala;

//  Objects to define agents that navigate our environment
//ArrayList<Agent> people = new ArrayList<Agent>();

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

//raise the Kabadiwala Army all at once
void initPopulation(int kabadiwalaNum) {
  //  Object to define and capture a specific origin, destination, and path
  
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  //1. make an arraylist of people 
  kabadiwalaArmy = new ArrayList<Agent>();
  
  //2. add kabadiwalas to the army along with their bundles and bundle paths
  for(int kab = 0; kab < 2; kab++){
    chooseKabadiwala(kab);
    ArrayList<Path> paths = new ArrayList<Path>();

    //2. for each bundle...
    for (int i=0; i<3; i++) {

      //reset hhDistArray
      hhDistArray = new ArrayList<Float>();
  
      //initialize bundle object
      Bundle b;
      
      //3. get the ID to find the unique path
      String composite_ID = str(kab+1)+"-"+str(i+1);  //gets composite ID of 1-1, 1-2, etc. 
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
    totalTripDistanceForKabadiwala = 0;
    for(int e = 0; e<bundleArray.size(); e++){
      //println("total trip distance: ",totalTripDistanceForKabadiwala);
      totalTripDistanceForKabadiwala += hh_dist_MergedMap.get(bundleArray.get(e).id);
    }
  
    //10. add agent to the path if the path has been parsed successfully
    if (paths.get(0).waypoints.size() > 1) { 
      float random_speed = 1.3;
      PVector loc = paths.get(0).waypoints.get(0); //get the full waypoints path
      
    //11. make an agent with the desired features, and the agent is associated with that bundle_path
    //populate kabadiwalaArmy with kabadiwalas

      println("making new person");
      Agent person = new Agent(loc.x, loc.y, 7, random_speed, paths, kab);
      //get paths from bundle assignment
      //get kabadiwalaNum from chooseKabadiwala
      //must chooseKabadiwala from kabadiwalaArmy
      //each kabadiwala has its own paths and kabadiwalaNum
      //but don't do pathToDraw until you have the entire kabadiwalaArmy assembled with its paths and numbers
      person.isAlive = true;
      person.id = kab;
      println("now inputting id into kabadiwala person, kabadiwalaNum is ",kab," and person id is",person.id);
      kabadiwalaArmy.add(person);
    }
      println("size of kabadiwala army is",kabadiwalaArmy.size());
      //println(kabadiwalaArmy);
      //println("the first agent is", kabadiwalaArmy.get(0));
      //println("the first agent's paths array is: ",kabadiwalaArmy.get(0).pathArray);
      //kabadiwalaArmy.get(0).pathToDraw = kabadiwalaArmy.get(0).pathArray.get(0);
      
      //raise the army!
      //they are following the same paths. they need to follow their own paths. 
      for(int personLabel = 0; personLabel<kabadiwalaArmy.size(); personLabel++){
        (kabadiwalaArmy.get(personLabel)).pathToDraw = (kabadiwalaArmy.get(personLabel)).pathArray.get(0);
      }
      
  }
}

ArrayList<PVector> personLocations(ArrayList<Agent> kabadiwalaArmy) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: kabadiwalaArmy) {
    l.add(a.location);
  }
  return l;
}




void checkAgentBehavior(){
  
  boolean collisionDetection = true;
  
  //check if Agent is alive
  for (Agent p: kabadiwalaArmy) {
    if(p.isAlive){
      p.update(personLocations(kabadiwalaArmy), collisionDetection);
      p.pathToDraw.display(100, 100); //draw path for agent to follow
      p.display(); //draw agent
      //display each of the bundles in bundleArray
      for(int e = 0; e<bundleArray.size(); e++){
        bundleArray.get(e).display(); //draw bundle
      }
    }
   
   //check if the bundle belongs to the correct kabadiwala
   //if any of the id's within the bundleArray list = p id
   for(int e = 0; e<bundleArray.size(); e++){
     //it appears that the bundle ID is not catching to the correct one
     
     
     
     
     
     String bundleId = String.valueOf(bundleArray.get(e).id.charAt(0));
     String kabadiId = str(p.id);
     println("bundle ID is",bundleId);
     println("kabadi ID is",kabadiId);
     Bundle s = bundleArray.get(e);
     
     if(bundleId.equals(kabadiId)){ //if the [1] in bundle id 1-1 or 1-2 = kabadiwala[1]       
       //initial conditions: bundle at source, agent in transit
       int euclideanAgentBundle = parseInt(dist(s.w, s.h, p.location.x, p.location.y));
       int euclideanOriginBundle = parseInt(dist(s.w, s.h, kabadiwala_loc.x, kabadiwala_loc.y));
       //int euclideanAgentSource = parseInt(dist(p.location.x, p.location.y, source.x, source.y));
       //int euclideanAgentOrigin = parseInt(dist(p.location.x, p.location.y, kabadiwala_loc.x, kabadiwala_loc.y));
   
       //1. when agent encounters bundle
       if(euclideanAgentBundle < 4 && euclideanOriginBundle > 4){ 
         s.w = p.location.x; 
         s.h = p.location.y;
         s.pickedUp = true;
         s.timesCollected = 1;
         soldToKabadiwala = true;
       }
   
       //2. bundle brought to kabadiwala, but still bundles to go 
       else if(euclideanOriginBundle <= 4 && p.stop == false){ 
         s.w = kabadiwala_loc.x; 
         s.h = kabadiwala_loc.y;
         s.pickedUp = false;     
         roundtripCompleted = true;  
         //roundtripKM = Math.round((hh_dist_MergedMap.get(s.id))*2*100.0/100.0); //for that s.id, total roundtrip distance
       }
       
       //stuff governing agent's behavior
       if(p.stop == true){
          roundtripKM = Math.round(totalTripDistanceForKabadiwala*2*100.0/100.0);
       }
       //3. bundle brought to kabadiwala, and finished track
           //println("sum: ",sum);
           //println(hhDistArray.get(i));
           //sum += hhDistArray.get(i);
         //}
       
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
