color k_fill = color(34,139,34);
//spring green color(173,255,47);
color mrf_fill = color(173,255,47);
color road_color = color(220,20,60);
//blue outline color(42,82,190);
color outline_color = color(211,211,211);
color ward_color = color(255,0,0);
color pop_title = color(255,255,255);
color pop_7 = color(128,128,128);
color pop_6 = color(149,149,149);
color pop_5 = color(170,170,170);
color pop_4 = color(192,192,192);
color pop_3 = color(213,213,213);
color pop_2 = color(234,234,234);
color pop_1 = color(244,244,244);

void drawInfo(){
  textSize(14);
  fill(255,255,255);
  text("Spatial Distribution of \nRecycling Aggregation \nPoints | Mumbai, India", width-170,height-250);
  
  //legend
  
  //recycling points
  textSize(12);
  fill(mrf_fill);
  text("MRF",width-170,height-190);
  fill(k_fill);
  text("Kabadiwala",width-170,height-170);
  
  //population gradient
  fill(pop_title);
  text("Population per sq km:",width-170,height-150);
  //population densities
  fill(pop_7);
  text("> 200,000",width-170,height-130);
  fill(pop_6);
  text("100,000-200,000",width-170,height-110);
  fill(pop_5);
  text("50,000-100,000",width-170,height-90);
  fill(pop_4);
  text("20,000-50,000", width-170,height-70);
  fill(pop_3);
  text("10,000-20,000", width-170, height-50);
  fill(pop_2);
  text("1,000-5,000", width-170, height-30);
  fill(pop_1);
  text("<1,000", width-170, height-10);
  
  //fill(road_color);
  //text("Streets", width-170, height-70);
  //fill(ward_color);
  //text("Ward Boundary",width-170,height-50);
  //fill(outline_color);
  //text("City Boundary",width-105,height-90);
  
}
