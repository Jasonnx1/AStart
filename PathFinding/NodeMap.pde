/********************
  Énumération des directions
  possibles
  
********************/
enum Direction {
  EAST, SOUTH, WEST, NORTH
}

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
  
********************/
class NodeMap extends Matrix {
  Node start;
  Node end;
  
  ArrayList<Node> openList;
  ArrayList<Node> closedList;  
  Node currentNode;
  
  ArrayList <Node> path;
  
  boolean debug = false;
  
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  void init() {
    
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      // Instanciation des rangees
      cells.add (new ArrayList<Cell>());
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
  
  /*
    Configure la cellule de départ
  */
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(baseColor);
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (127, 0, 127));
  }
  
  /*
    Configure la cellule de fin
  */
  void setEndCell (int i, int j) {
    
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(baseColor);
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    
    end.setFillColor(color (127, 127, 0));
  }
  
  /** Met a jour les H des cellules
  doit etre appele apres le changement du noeud
  de debut ou fin
  */
  void updateHs() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node current = (Node)cells.get(j).get(i); 
        current.setH( calculateH(current));
      }
    }
  }
  
  // Permet de generer aleatoirement le cout de deplacement
  // entre chaque cellule
  void randomizeMovementCost() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        
        int cost = parseInt(random (0, cols)) + 1;
        
        Node current = (Node)cells.get(j).get(i);
        current.setMovementCost(cost);
       
      }
    }
  }
  
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  /**
    Génère les voisins de chaque Noeud
    Pas la méthode la plus efficace car ça
    prend beaucoup de mémoire.
    Idéalement, on devrait le faire au besoin
  */
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        generateNeighbours(i, j);
      }
    }
  }
  
  /*
    Permet de trouver le chemin le plus court entre
    deux cellules
  */
  void findAStarPath () {
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    }
    else
    {
      
      
       currentNode = start; 
       openList = new ArrayList<Node>();
       closedList = new ArrayList<Node>();         
       openList.add(start);
       start.G = 0;
      
      while(openList.size() > 0)
      {
 
        currentNode = getLowestCost(openList);
        
        if(currentNode == end)
        {          
         openList.clear();
        }
        else
        {
          
          openList.remove(currentNode);
          closedList.add(currentNode);
          
          if(currentNode != null)
          {
            for(Node n : currentNode.neighbours)
            {               
              
                n.setMovementCost(calculateCost(currentNode, n)); 
              
               if(!(closedList.contains(n)))
               {
                
                 if(n.isWalkable)
                 {
                   int Gprime = currentNode.getG() + n.movementCost; 
                   
                   if(Gprime >= n.getG())
                   {
                       
                   }                 
                   else
                   {
                     if(!openList.contains(n))
                     {
                       openList.add(n);
                     }
                  
                       n.setParent(currentNode);
                       n.G = Gprime;
                     
                       
                   }
                                   
                 }              
             }
              
           }
          }
          else
          {            
            openList.clear();
          }
   
        }

      }
               
               generatePath();
    }
    
  }
  
  /*
    Permet de générer le chemin une fois trouvée
  */
  void generatePath () {
    path = new ArrayList<Node>();
    boolean done = false;
    Node v = end.getParent();
    
    try
    {
          while(!done)
          {      
                path.add(v);
                if(v.getParent() != start)  {
                  v = v.getParent();
                } else {
                  done = true;
                }
          }
    } catch(Exception e){print(e);};
    

  }
  
  /**
  * Cherche et retourne le noeud le moins couteux de la liste ouverte
  * @return Node le moins couteux de la liste ouverte
  */
  private Node getLowestCost(ArrayList<Node> openList) {
    
    Node result = null;
    
    for(Node n : openList)
    {
        if(n.isWalkable == true)
        {
            if(result == null)
            {
              result = n;         
            }
            else
            {             
              if(n.getF() < result.getF())
              {
                result = n;
              }
              
            }
            
        }
    }
    
    return result;
  }
  

  
 /**
  * Calcule le coût de déplacement entre deux noeuds
  * @param nodeA Premier noeud
  * @param nodeB Second noeud
  * @return
  */
  private int calculateCost(Cell nodeA, Cell nodeB) {
    int cost = 14;
      
    if(nodeA.x == nodeB.x)
    {
      cost = 10; 
    }    
    else if(nodeA.y == nodeB.y)
    {
      cost = 10;
    }

    return cost;
  }
  
  
  /**
  * Calcule l'heuristique entre le noeud donnée et le noeud finale
  * @param node Noeud que l'on calcule le H
  * @return la valeur H
  */
  private int calculateH(Cell node) {
        int H = 0;
    
    if(node.i > end.i)
    {
      
      H += node.i - end.i;
      
    }
    else
    {
     H += end.i - node.i; 
    }
    
    if(node.j > end.j)
    {
      
      H += node.j - end.j;
      
    }
    else
    {
     H += end.j - node.j; 
    }
    
    H *= 10;
    
    return H;
  }
  
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        Node current = (Node)cells.get(j).get(i);
        
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
  // Permet de créer un mur à la position _i, _j avec une longueur
  // et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length > rows ? rows: _j + _length;  
      
      for (int j = _j; j < max; j++) {
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
      }       
    } else {
      max = _i + _length > cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
