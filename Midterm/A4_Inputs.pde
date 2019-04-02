//set the costs and quantities (can change these dynamically)

//only set Sources that are 1-3km from the shop
int dist_from_shop = 3000;

//paper
int kabadiwala_pickup_cost_paper;
int paperKBuy = 10;
int paperQuantity = 1500;
int kabadiwala_offload_cost_paper;
int paperKSell = 12;

//plastic
int kabadiwala_pickup_cost_plastic;
int plasticKBuy = 12; 
int plasticQuantity = 120; 
int kabadiwala_offload_cost_plastic;
int plasticKSell = 20;

//glass
int kabadiwala_pickup_cost_glass;
int glassKBuy = 1; 
int glassQuantity = 60; 
int kabadiwala_offload_cost_glass;
int glassKSell = 4;

//metal
int kabadiwala_pickup_cost_metal;
int metalKBuy = 80; 
int metalQuantity = 10; 
int kabadiwala_offload_cost_metal;
int metalKSell = 100;

//misc
int misc = 3000;

//profit
int totalKPickupCost;

//distance calculation
float HavD;
int roundtripKM;
