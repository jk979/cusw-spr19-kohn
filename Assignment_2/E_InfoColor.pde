color poi_fill = color(255, 99, 71); //any point color
color restaurant = color(255, 255, 0); //if poi is restaurant
color mit = color(32, 178, 170); 
color polygon_fill = color(32, 255, 170);
color road_color = color(100, 149, 237);

void drawInfo(){ 
  //Rectangle
  fill(0);
  rect(20, 20, 125, 90);
  textSize(16);
  //POI
  fill(poi_fill);
  text("poi", 25, 40);
  //Restaurant
  fill(restaurant);
  text("Restaurants!", 25, 60);
  fill(road_color);
  text("Roads", 25, 80);
  fill(polygon_fill);
  text("Buildings", 25, 100);
}
