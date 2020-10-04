NodeMap worldMap;

int deltaTime = 0;
int previousTime = 0;

int mapRows = 10;
int mapCols = 10;

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
  
  worldMap.setBaseColor(baseColor);
  

  
  worldMap.setStartCell((int)random(mapCols), (int)random(mapRows));
  worldMap.setEndCell((int)random(mapCols), (int)random(mapRows));
  worldMap.generateNeighbourhood();
  while(worldMap.start.neighbours.contains(worldMap.end) || (worldMap.start == worldMap.end ) )
  {
    
    worldMap.setStartCell((int)random(mapCols), (int)random(mapRows));
    worldMap.setEndCell((int)random(mapCols), (int)random(mapRows));
    worldMap.generateNeighbourhood();
    
  }
  
  
  // Mise à jour de tous les H des cellules
  worldMap.updateHs();
    
  worldMap.generateNeighbourhood(); //<>//
      
  worldMap.findAStarPath();
}

void keyPressed()
{
  switch(key)
  {
    case 'r': setup();
  }
}
