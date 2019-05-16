// Objects to define our Network

//objective today: 
//get MRFs and wholesalers to start new course

//
ObstacleCourse course;
Graph network;
Pathfinder finder;
boolean pathNotFound; //pathNotFound is a global variable

import java.util.*;
float laps; 

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

//raise the wholesaler army
void initWholesalers(){
  //1. make arraylist of people
  wholesalerArmy = new ArrayList<Agent2>();
  
  //2. add wholesalers to army along with their bundle paths
  for(int w = w_min; w<w_max; w++){
    chooseWholesaler(w); 
    ArrayList<Path> paths = new ArrayList<Path>();
    
    //get list of possible wards
    ArrayList<String> w_wards = new ArrayList<String>();
    w_wards.add("HW-sector1");
    w_wards.add("HW-sector2");
    w_wards.add("HW-sector3");
    w_wards.add("HW-sector4");
    w_wards.add("HW-sector5");
    w_wards.add("HW-sector6");
    w_wards.add("HW-remainder");
    
    w_wards.add("N-sector1");
    w_wards.add("N-sector2");
    w_wards.add("N-sector3");
    w_wards.add("N-sector4");
    w_wards.add("N-remainder");
    
    w_wards.add("RN-sector1");
    w_wards.add("RN-sector2");
    w_wards.add("RN-sector3");
    w_wards.add("RN-sector4");
    w_wards.add("RN-sector5");
    
    //for each path...
    for(int i=0; i<w_wards.size(); i++){
      String w_composite_ID = "W-"+w_wards.get(i);
      //add current path to list of paths
      ArrayList<PVector> wholesaler_array = MRFMergedMap.get(w_composite_ID);
      println("wholesaler array size: ",wholesaler_array.size());
      Path n = new Path(w_loc, w_loc, wholesaler_array, true);
      paths.add(n); //added the single bundle path to this bundle 
    }
    
    //10. add agent to the path if the path has been parsed successfully
    println("paths size is ",paths.size());
    if (paths.get(0).waypoints.size() > 1) { 
      PVector loc = paths.get(0).waypoints.get(0); //get the full waypoints path
    //11. make an agent with the desired features, and the agent is associated with that bundle_path
    //populate wholesalerArmy with w collectors

      println("making new person");
      Agent2 wperson = new Agent2(loc.x, loc.y, 2, wholesaler_speed, paths, w);
      wperson.isAlive = true;
      wperson.id = w;
      wperson.type = "w";

      println("now inputting id into w person, wNum is ",w," and person id is",wperson.id);
      wholesalerArmy.add(wperson);
    }
      println("size of MRF army is",wholesalerArmy.size());

      //raise the army!
      for(int personLabel = 0; personLabel<wholesalerArmy.size(); personLabel++){
        (wholesalerArmy.get(personLabel)).pathToDraw = (wholesalerArmy.get(personLabel)).pathArray.get(0);
      }
    }  
}
    

//raise the MRF Army
void initMRFs(){
  //1. make arraylist of people
  mrfArmy = new ArrayList<Agent2>();
  
  //2. add MRFs to army along with their bundle paths
  for(int m = m_min; m < m_max; m++){
    chooseMRF(m);
    ArrayList<Path> paths = new ArrayList<Path>();
    
    //get list of possible wards
    ArrayList<String> mrfwards = new ArrayList<String>();
    if(m == 17){
      mrfwards.add("HW17-sector1");
      mrfwards.add("HW17-sector2");
      mrfwards.add("HW17-sector3");
      mrfwards.add("HW17-remainder");
    }
    else if(m == 18){
    mrfwards.add("HW18-sector1");
    mrfwards.add("HW18-sector3");
    mrfwards.add("HW18-sector2");
    mrfwards.add("HW18-remainder");
    }
    else if(m == 36){
      mrfwards.add("N-sector1");
      mrfwards.add("N-sector2");
      mrfwards.add("N-sector3");
      mrfwards.add("N-sector4");
      mrfwards.add("N-remainder");
    }
    else if(m == 30){
      mrfwards.add("RN30-sector1");
      mrfwards.add("RN30-sector2");
      mrfwards.add("RN30-remainder");
    }
    else if(m == 31){
      mrfwards.add("RN31-sector1");
      mrfwards.add("RN31-sector2");
      mrfwards.add("RN31-remainder");
    }
     
    //for each path...
    for(int i=0; i<mrfwards.size(); i++){
      String mrf_composite_ID = "MRF-"+mrfwards.get(i);
      println("mrf composite id: ",mrf_composite_ID);
      //add current path to list of paths
      ArrayList<PVector> mrf_array = MRFMergedMap.get(mrf_composite_ID);
      Path n = new Path(mrf_loc, mrf_loc, mrf_array, true);
      paths.add(n); //added the single bundle path to this bundle 
    }
    
    //10. add agent to the path if the path has been parsed successfully
    println("paths size is ",paths.size());
    if (paths.get(0).waypoints.size() > 1) { 
      PVector loc = paths.get(0).waypoints.get(0); //get the full waypoints path
      mrf_loc = new PVector(loc.x, loc.y);
      
    //11. make an agent with the desired features, and the agent is associated with that bundle_path
    //populate mrfArmy with mrf collectors

      println("making new person");
      Agent2 mrfperson = new Agent2(loc.x, loc.y, 2, mrf_speed, paths, m);
      mrfperson.isAlive = true;
      mrfperson.id = m;
      mrfperson.type = "m";

      println("now inputting id into MRF person, mrfNum is ",m," and person id is",mrfperson.id);
      mrfArmy.add(mrfperson);
    }
      println("size of MRF army is",mrfArmy.size());

      //raise the army!
      for(int personLabel = 0; personLabel<mrfArmy.size(); personLabel++){
        (mrfArmy.get(personLabel)).pathToDraw = (mrfArmy.get(personLabel)).pathArray.get(0);
      }
    }  
}

//raise the Kabadiwala Army all at once
void initPopulation() {
  //  Object to define and capture a specific origin, destination, and path
  
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  //1. make an arraylist of people 
  kabadiwalaArmy = new ArrayList<Agent>();
  //ArrayList<Float> graphArray = new ArrayList<Float>(); //holds all the points in the graphArray of all kabadiwalas; access through kabadiwala index
  println("size of kabadiwalaArmy before filling is",kabadiwalaArmy.size());
  println("size of graphArray befoe filling is",graphArray.size());

  //2. add kabadiwalas to the army along with their bundles and bundle paths
  for(int kab = k_min; kab < k_max; kab++){
    println("looping through kabadiwalas, going to fill graphArray");
    chooseKabadiwala(kab);
    ArrayList<Path> paths = new ArrayList<Path>();

    //make a graphArray to track distance
    totalTripDistanceForKabadiwala = 0; //initialize kabadiwala's total trip distance as 0

    //2. for each bundle...
    for (int i=0; i<numBundlesPerKabadiwala; i++) {

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
   
    
    //fill in his total trip distance by summing the distance to all his bundle arrays
    for(int e = 0; e<bundleArray.size(); e++){
      totalTripDistanceForKabadiwala += hh_dist_MergedMap.get(bundleArray.get(e).id);
    }
    
    //when this is all added, it's the total trip distance for that kabadiwala for all bundles
    //[1:20, 2:40, 3:30]
    graphArray.add(totalTripDistanceForKabadiwala);
    println("the distance for kabadiwala "+str(kab)+" is ",graphArray.get(kab));
  
    //10. add agent to the path if the path has been parsed successfully
    if (paths.get(0).waypoints.size() > 1) { 
      PVector loc = paths.get(0).waypoints.get(0); //get the full waypoints path
      
    //11. make an agent with the desired features, and the agent is associated with that bundle_path
    //populate kabadiwalaArmy with kabadiwalas

      println("making new person");
      Agent person = new Agent(loc.x, loc.y, 2, kabadiwala_speed, paths, kab);
      person.isAlive = true;
      person.id = kab;
      person.type = "k";
      println("now inputting id into kabadiwala person, kabadiwalaNum is ",kab," and person id is",person.id);
      kabadiwalaArmy.add(person);
    }
      println("size of kabadiwala army is",kabadiwalaArmy.size());
      println("graph array looks like ",graphArray);
      println("size of graph array is ",graphArray.size());
      
      //raise the army!
      for(int personLabel = 0; personLabel<kabadiwalaArmy.size(); personLabel++){
        (kabadiwalaArmy.get(personLabel)).pathToDraw = (kabadiwalaArmy.get(personLabel)).pathArray.get(0);
      }
      
  }
}

ArrayList<PVector> wpersonLocations(ArrayList<Agent2> wholesalerArmy) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent2 a: wholesalerArmy) {
    l.add(a.location);
  }
  return l;
}

ArrayList<PVector> mrfpersonLocations(ArrayList<Agent2> mrfArmy) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent2 a: mrfArmy) {
    l.add(a.location);
  }
  return l;
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
  
  for(Agent2 d: wholesalerArmy){
    if(d.isAlive){
      d.update(wpersonLocations(wholesalerArmy), collisionDetection);
      d.display();
      stroke(w_fill);
      d.pathToDraw.display(50,50);
      
      for(int e = 0; e<bundleArray.size(); e++){     
        Bundle s = bundleArray.get(e);
        int euclideanAgentBundle = parseInt(dist(s.w, s.h, d.location.x, d.location.y));
        int euclideanOriginBundle = parseInt(dist(s.w, s.h, w_loc.x, w_loc.y));
        //1. when agent encounters bundle
        if(euclideanAgentBundle < 4 && euclideanOriginBundle > 4){ 
         s.w = d.location.x; 
         s.h = d.location.y;
         s.pickedUp = true;
         s.timesCollected = 1;
         soldToKabadiwala = true;
        }
   
        //2. bundle brought to kabadiwala, but still bundles to go 
        else if(euclideanOriginBundle <= 4 && d.stop == false){ 
         s.w = w_loc.x; 
         s.h = w_loc.y;
         s.pickedUp = false;     
         roundtripCompleted = true;  
         //roundtripKM = Math.round((hh_dist_MergedMap.get(s.id))*2*100.0/100.0); //for that s.id, total roundtrip distance
        }
      } 
    }
  }
  
  for(Agent2 t : mrfArmy) { //stealing happens...
    if(t.isAlive){
      t.update(mrfpersonLocations(mrfArmy), collisionDetection);
      t.display();
      stroke(mrf_fill);
      t.pathToDraw.display(50,50);
      
      for(int e = 0; e<bundleArray.size(); e++){
        Bundle s = bundleArray.get(e);
        
        //determine the size of the bundle to pick up
        //add them to the group of things to pick up if the picking boolean is true
        
        Block a = s.plastic;
        Block b = s.paper;
        Block c = s.glass;
        Block d = s.metal;
        
        //intersect with the bundle and pick up its materials
        
        //int euclideanAgentBundle = parseInt(dist(s.w, s.h, t.location.x, t.location.y));
        //int euclideanOriginBundle = parseInt(dist(s.w, s.h, mrf_loc.x, mrf_loc.y));

        
        int euclideanAgentBundle_plastic = parseInt(dist(a.loc_x, a.loc_y,  t.location.x, t.location.y));    
        int euclideanOriginBundle_plastic = parseInt(dist(a.loc_x, a.loc_y, mrf_loc.x, mrf_loc.y));
        
        int euclideanAgentBundle_paper = parseInt(dist(b.loc_x, b.loc_y,  t.location.x, t.location.y));
        int euclideanOriginBundle_paper = parseInt(dist(b.loc_x, b.loc_y, mrf_loc.x, mrf_loc.y));
        
        int euclideanAgentBundle_glass = parseInt(dist(c.loc_x, c.loc_y,  t.location.x, t.location.y));
        int euclideanOriginBundle_glass = parseInt(dist(c.loc_x, c.loc_y, mrf_loc.x, mrf_loc.y));
        
        int euclideanAgentBundle_metal = parseInt(dist(d.loc_x, d.loc_y,  t.location.x, t.location.y));
        int euclideanOriginBundle_metal = parseInt(dist(d.loc_x, d.loc_y, mrf_loc.x, mrf_loc.y));
        
        ////////////PRINTING DISTANCE BETWEEN BUNDLE AND MRF LOC///////////////
        //println(euclideanAgentBundle, euclideanOriginBundle, d.loc_x, d.loc_y, mrf_loc.x, mrf_loc.y);
        println(d.loc_x, d.loc_y);
        //1. when agent encounters bundle
        if(euclideanAgentBundle_metal < 4 && euclideanOriginBundle_metal > 4){ 
          d.carry(t.location.x, t.location.y,2);   
        }
        /*
        if(euclideanAgentBundle_paper < 4 && euclideanOriginBundle_paper > 4 && pickingPaper == true){ 
          b.carry(t.location.x, t.location.y,2);   
          //s.pickedUp = true;
        }
        if(euclideanAgentBundle_glass < 4 && euclideanOriginBundle_glass > 4 && pickingGlass == true){ 
          c.carry(t.location.x, t.location.y,2);   
          //s.pickedUp = true;
        }
        if(euclideanAgentBundle_metal < 4 && euclideanOriginBundle_metal > 4 && pickingMetal == true){ 
          d.carry(t.location.x, t.location.y,2);   
          //s.pickedUp = true;
        }
        */
   
        //2. bundle brought to mrf, but still bundles to go 
        else if(euclideanOriginBundle_metal <= 4 && t.stop == false){ 
          //println("block was drobbed by mrf");
          d.drop(mrf_loc.x, mrf_loc.y);
          roundtripCompleted = true;  
        }
      } 
    }
  }
  
  //check if Agent is alive
  for (Agent p: kabadiwalaArmy) {
    if(p.isAlive){
      p.update(personLocations(kabadiwalaArmy), collisionDetection);
      p.display(); //draw agent
      stroke(k_fill);
      p.pathToDraw.display(50, 50); //draw path for agent to follow
      //display each of the bundles in bundleArray
      for(int e = 0; e<bundleArray.size(); e++){
        bundleArray.get(e).display(); //draw bundle
      }
   
      //check if the bundle belongs to the correct kabadiwala
      if(!p.stop) {
        //if any of the id's within the bundleArray list = p id
        for(int e = 0; e<bundleArray.size(); e++){     
          String bundleId = String.valueOf(bundleArray.get(e).id.charAt(0));
          String kabadiId = str(p.id+1);
          Bundle s = bundleArray.get(e);
         
          if(bundleId.equals(kabadiId)){ //if the [1] in bundle id 1-1 or 1-2 = kabadiwala[1]       
            //initial conditions: bundle at source, agent in transit
            int euclideanAgentBundle = parseInt(dist(s.w, s.h, p.location.x, p.location.y));
            int euclideanOriginBundle = parseInt(dist(s.w, s.h, kabadiwala_loc.x, kabadiwala_loc.y));
         
            //1. when agent encounters bundle
            if(euclideanAgentBundle < 4 && euclideanOriginBundle > 4){ 
               s.carryAll(p.location.x, p.location.y);
               s.pickedUp = true;
               s.timesCollected = 1;
               soldToKabadiwala = true;
            }
         
            //2. bundle brought to kabadiwala, but still bundles to go 
            else if(euclideanOriginBundle <= 4 && p.stop == false){ 
               s.carryAll(kabadiwala_loc.x, kabadiwala_loc.y);
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
          }
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
