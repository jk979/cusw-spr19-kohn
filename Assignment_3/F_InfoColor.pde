color k_fill = color(240,248,255);
//spring green color(173,255,47);
color mrf_fill = color(173,255,47);
color road_color = color(220,20,60);
//blue outline color(42,82,190);
color outline_color = color(211,211,211);
color ward_color = color(211,211,211);

void drawInfo(){
  //Rectangle
  //fill(105,105,105);
  //rect(width-110,height-200,200,200);
  //title
  textSize(14);
  fill(255,255,255);
  text("Spatial Distribution of \nRecycling Aggregation \nPoints | Mumbai, India", width-170,height-200);
  
  //legend
  textSize(12);
  fill(mrf_fill);
  text("MRF",width-170,height-110);
  fill(k_fill);
  text("Kabadiwala",width-170,height-90);
  fill(road_color);
  text("Streets", width-170, height-70);
  fill(ward_color);
  text("Ward Boundary",width-170,height-50);
  //fill(outline_color);
  //text("City Boundary",width-105,height-90);
  
}
