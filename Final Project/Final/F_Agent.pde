///two types of Agents: kAgents and wAgents. 
//kAgents have type "k" and they collect from Sources. They can only move back and forth from Kabadiwala Shop to Source. 
//wAgents have type "w" and they collect from Kabadiwala shops. They can only move in a circular path from shop to shop. 

class KabadiwalaAgent{
  float w, h;
  String id;
  
  //constructor
  KabadiwalaAgent(float wpos, float hpos){
    w = wpos;
    h = hpos;
  }
  
  void display(){
    fill(k_fill);
    smooth();
    noStroke();
    render();
  }
  
  void render() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(w + (i * width), h + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}
}

class MRFAgent{
  float w, h;
  String id;
  
  //constructor
  MRFAgent(float wpos, float hpos){
    w = wpos;
    h = hpos;
  }
  
  void display(){
    fill(mrf_fill);
    smooth();
    noStroke();
    render();
  }
  
  void render() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(w + (i * width), h + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}
}
  
  
class WholesalerAgent{
  float w, h;
  String id;
  
  //constructor
  WholesalerAgent(float wpos, float hpos){
    w = wpos;
    h = hpos;
  }
  
  void display(){
    fill(w_fill);
    smooth();
    noStroke();
    render();
  }
  
  void render() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(w + (i * width), h + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}
}

////////////////////////////////




class Agent {
  //movement properties
  PVector location;
  PVector velocity;
  PVector acceleration;
  Path pathToDraw;
  float r;
  float maxforce;
  float maxspeed;
  float tolerance = 1;
  ArrayList<Path> pathArray;
  int pathArrayIndex = 0;
  boolean stop = false;
  Path currentPath;
  ArrayList<PVector> path;
  
  int id; 
  int pathIndex, pathLength; // Index and Amount of Nodes in a Path
  int pathDirection; // -1 or +1 to specific directionality
  
  //pickup properties
  boolean isCarrying; //is it carrying a Bundle?
  boolean atSource; //is it at the Source?
  boolean atKabadiwala; //is it at the Kabadiwala Shop?
  String type; //is it type k or w?
  int collectFrom; //how many stops does it take before returning to the origin? kAgents = 1, wAgents = 10
  ArrayList<String> daysCollected = new ArrayList<String>(); //which days does it do this?
  
  boolean isAlive;

  //agent constructor
  Agent(float x, float y, int rad, float maxS, ArrayList<Path> pathArray) {
    isAlive = true;
    r = rad;
    tolerance *= r;
    maxspeed = maxS;
    maxforce = 0.2;
    
    //pathArray is all the possible paths Agent can traverse
    this.pathArray = pathArray;
    this.currentPath = pathArray.get(0); //gets the current path
    //path is all the waypoints in their current path waypoint set
    path = currentPath.waypoints;
    
    pathLength = path.size();
    if (random(-1, 1) <= 0 ) {
      pathDirection = -1;
    } else {
      pathDirection = +1;
    }
    float jitterX = random(-tolerance, tolerance);
    float jitterY = random(-tolerance, tolerance);
    location = new PVector(x + jitterX, y + jitterY);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    pathIndex = getClosestWaypoint(location);
  }
  
  PVector seek(PVector target){
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    return steer;
  }
  
  PVector separate(ArrayList<PVector> others){
    float desiredseparation = 0.5 * r;
    PVector sum = new PVector();
    int count = 0;
    
    for(PVector location : others) {
      float d = PVector.dist(location, location);
      
      if ((d > 0 ) && (d < desiredseparation)){
        
        PVector diff = PVector.sub(location, location);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
   return sum;   
  }
  
  // calculates the index of path node closest to the given canvas coordinate 'v'.
  // returns 0 if node not found.
  //
  int getClosestWaypoint(PVector v) {
    int point_index = 0;
    float distance = Float.MAX_VALUE;
    float currentDist;
    PVector p;
    for (int i=0; i<path.size(); i++) {
      p = path.get(i);
      currentDist = sqrt( sq(v.x-p.x) + sq(v.y-p.y) );
      if (currentDist < distance) {
        point_index = i;
        distance = currentDist;
      }
    }
    return point_index;
  }
  
  void update(ArrayList<PVector> others, boolean collisionDetection) {
    
    ////is path done? (in update)
    ////each agent gets a set of 7 paths to traverse one at a time
    ////loop through the path array and show the current path
    //for(int i = 0; i<pathArray.size();i++){
    //  println("path array size is",pathArray.size());
    //  println("getting current path for i = ",i);
    //  currentPath = pathArray.get(i);
    //  println("currentPath is now",currentPath);
    //  path = currentPath.waypoints;
    //  //println("path of waypoints is now",path);
    //}
    
    //go to next path
    //path = paths(i+1)
    
    // Apply Repelling Force
    PVector separateForce = separate(others);
    if (collisionDetection) {
      separateForce.mult(3);
      acceleration.add(separateForce);
    }
    
    // Apply Seek Force
    PVector waypoint = path.get(pathIndex);
    float jitterX = random(-tolerance, tolerance);
    float jitterY = random(-tolerance, tolerance);
    //PVector direction = new PVector(waypoint.x + jitterX, waypoint.y + jitterY);
    PVector direction = new PVector(waypoint.x, waypoint.y);
    PVector seekForce = seek(direction);
    seekForce.mult(1);
    acceleration.add(seekForce);
    
    if (!stop) {
      // Update velocity
      velocity.add(acceleration);
      
      // Update Location
      location.add(new PVector(velocity.x, velocity.y));
          
      // Limit speed
      velocity.limit(maxspeed);
      
      // Reset acceleration to 0 each cycle
      acceleration.mult(0);
    }
    
    
    // Checks if Agents reached current waypoint
    // If reaches endpoint, reverses direction
    //
    float prox = sqrt( sq(location.x - waypoint.x) + sq(location.y - waypoint.y) );
    if (prox < 3 && path.size() > 1 ) {
      if (pathDirection == 1 && pathIndex == pathLength-1 || pathDirection == -1 && pathIndex == 0) {
        pathDirection *= -1;
        
        // If back to the beginning, move on to the next path
        if (pathDirection == 1) {
          
          // increment path index
          pathArrayIndex++;
          if(pathArrayIndex < pathArray.size()) {
            path = pathArray.get(pathArrayIndex).waypoints;
            pathToDraw = pathArray.get(pathArrayIndex);
            pathLength = path.size();
            println(pathArrayIndex);
          } else {
            stop = true;
          }
        }
      }
      pathIndex += pathDirection;
    }
    
  }
  
  void display(){
    fill(18,247,41);
    smooth();
    noStroke();
    render();
  }
  
  void render() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(location.x + (i * width), location.y + (j*height));
      if ( pathDirection == 1) { 
        rotate(PI);
      }
      if ( pathDirection == -1) { 
        //rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}
}
