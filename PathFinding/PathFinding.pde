NodeMap worldMap;

int deltaTime = 0;
int previousTime = 0;

int mapRows = 100;
int mapCols = 100;

color baseColor = color (0, 127, 0);

void setup () {
  size (1080, 720);
  initMap();
}

void draw () {
  deltaTime = millis () - previousTime;
  previousTime = millis();
  
  update(deltaTime);
  display();
}

void update (float delta) {
  worldMap.update(delta);
}

void display () {
  
  if (worldMap.path != null) {
    for (Cell c : worldMap.path) {
      try{
        
        c.setFillColor(color (127, 0, 0));
      } catch(Exception e){ print(e.toString());};
      
    }
  }
  
  worldMap.display();
}

void initMap () {
  worldMap = new NodeMap (mapRows, mapCols); 
  
  
  makeMap();
  worldMap.setBaseColor(baseColor);
  
  
 /*
  * Make Sure They don't spawn on the same tile or side-by-side.
  */
  worldMap.setStartCell((int)random(mapCols), (int)random(mapRows));
  worldMap.setEndCell((int)random(mapCols), (int)random(mapRows));
  worldMap.generateNeighbourhood();
  while( worldMap.start.isWalkable == false || worldMap.end.isWalkable == false || worldMap.start.neighbours.contains(worldMap.end) || (worldMap.start == worldMap.end )  )
  {
    
    worldMap.setStartCell((int)random(mapCols), (int)random(mapRows));
    worldMap.setEndCell((int)random(mapCols), (int)random(mapRows));
    worldMap.generateNeighbourhood();
    
  }
  
  makeMap();

  
  
  // Mise à jour de tous les H des cellules
  worldMap.updateHs();
  
  
    
  worldMap.generateNeighbourhood(); //<>//
      
  worldMap.findAStarPath();
}

void makeMap()
{
  
  
  
  worldMap.makeWall(mapCols/2, mapRows/4, 40, true);
  worldMap.makeWall(mapCols/2+1, mapRows/4, 40, false);
  worldMap.makeWall(mapCols/2-10, mapRows/4, 10, true);
  worldMap.makeWall(mapCols/2-8, mapRows/4, 10, true);
  
   worldMap.makeWall(mapCols/2, mapRows/2, 10, false);
   worldMap.makeWall(mapCols/2, mapRows/2, 10, false);

  
}

void keyPressed()
{
  switch(key)
  {
    case 'r': setup();
  }
}
