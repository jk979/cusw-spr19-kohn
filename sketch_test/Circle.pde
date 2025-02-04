/*
class Circle
{
  PVector pos;
  PVector forward;
  float speed;
  color c;
  int cw = 0;
  
  Circle()
  {
    respawn();
  }
  
  void respawn()
  {
    pos = new PVector(-50, random(0, height));
    c = color(random(200, 255), random(200, 255), random(200, 255));
    speed = 3;
  }
  
  void update()
  {
    PVector waypoint = waypoints.get(cw);
    forward = PVector.sub(waypoint, pos);
    forward.normalize();
    pos.add(PVector.mult(forward, speed));
    if (dist(waypoint.x, waypoint.y, pos.x, pos.y) < 10)
    {
      cw = (cw + 1) % waypoints.size();
    }
  }
  
  void render()
  {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, 20, 20);
  }  
}
*/
