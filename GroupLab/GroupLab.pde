interface Displayable {
  void display();
}

interface Moveable {
  void move();
}

interface Collideable {
  boolean isTouching(Thing other);
}


abstract class Thing implements Displayable, Collideable {
  float x, y;//Position of the Thing

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
  abstract void display();
  boolean isTouching(Thing other) {
    return dist(x, y, other.x, other.y) < 50;
  }
}

class Rock extends Thing {
  PImage img;
  Rock(float x, float y, PImage image) {
    super(x, y);
    if ((int)random(2) == 0) {
      img = image;
    } else {
      img = image;
    }
  }


  void display() {
    image(img, x, y, 50, 50);
  }
}

public class LivingRock extends Rock implements Moveable {
  int[] path1X = new int[]{2, 1, 0, 2, 1, 2, 0, 1};
  int[] path1Y = new int[]{0, 1, 2, 1, 0, 1, 2, 1};
  int[] path2X = new int[]{0, 2, 1, 0, 2, 1, 1, 0};
  int[] path2Y = new int[]{2, 1, 0, 1, 0, 2, 1, 1};
  int[] path3X = new int[]{1, 0, 1, 0, 2, 1, 1, 2};
  int[] path3Y = new int[]{1, 2, 0, 1, 1, 2, 1, 0};

  int[][] allPathsX = new int[][]{path1X, path2X, path3X};
  int[][] allPathsY = new int[][]{path1Y, path2Y, path3Y};
  int[] randomPathX;
  int[] randomPathY;
  int randomNum;
  int XMODE;
  int YMODE;

  int counter = 0;
  LivingRock(float x, float y, PImage image) {
    super(x, y, image);
    randomNum = (int)random(3);
    randomPathX = allPathsX[randomNum];
    randomPathY = allPathsY[randomNum];
    XMODE = 0;
    YMODE = 0;
  }
  boolean isTouching(Thing other) {
    return abs(x - (other.x - 10)) < 10 && abs(y - (other.y - 20)) < 10;
  }
  int isTouchingDetectSides(Thing other) {
    if (abs(x - other.x) < 10) {
      if (y - other.y <= -10 && y - other.y > 20) {
        return 1; //ball hit the top part of collideable
      }
      if (y - other.y >= 10 && y - other.y < 20) {
        return 3; //ball hit the bottom part of collideable
      }
    }
    if (abs(y - other.y) < 10) {
      if (x - other.x > -20 && x - other.x <= -10) {
        return 2; //ball hit the left side of collideable
      }
      if (x - other.x < 20 && x - other.x >= 10) {
        return 4; //ball hit the right side of collideable
      }
    }
    return -1;
  }
  
  void move() {
    int xIncr = randomPathX[counter] * (int)random(6);
    int yIncr = randomPathX[counter] * (int)random(6);
    if (x + 30 > width || x < 0) {
      if (x + 30 > width) {
        x-= 10;
      } else {
        x+= 10;
      }
      XMODE++;
    }
    if (y + 30 > height || y < 0) {
      if (y + 30 > height) {
        y -= 10;
      } else {
        y += 10;
      }
      YMODE++;
    }
    if (XMODE % 2 == 1) {
      xIncr *= -1;
    }
    if (YMODE % 2 == 1) {
      yIncr *= -1;
    }
    for ( Thing c : thingsToCollide) {
      if (this != c) {
        if ( isTouchingDetectSides(c) == 1) {
          YMODE++;
          y-= 10;
        } else if (isTouchingDetectSides(c) == 3){
          YMODE++;
          y+= 10;
        } else if (isTouchingDetectSides(c) == 2){
          XMODE++;
          x-= 10;
        } else if (isTouchingDetectSides(c) == 4){
          XMODE++;
          x+= 10;
        }
      }
    }
    x += xIncr;
    y += yIncr;
    if (counter == randomPathX.length -1) {
      counter = 0;
    } else {
      counter++;
    }
  }
  void display() {
    super.display();
    fill(255, 255, 255);
    ellipse(x+19, y+20, 10, 10);
    ellipse(x+29, y+20, 10, 10);
    fill(0, 0, 0);
    ellipse(x+19+random(-4, 4), y+20+random(-4, 4), 3, 3);
    ellipse(x+29+random(-4, 4), y+20+random(-4, 4), 3, 3);
  }
}

class Ball extends Thing implements Moveable {
  float speedx = random(6);
  float speedy = random(6);
  float[] col = {random(255), random(255), random(255)};
  float og0 = col[0];
  float og1 = col[1];
  float og2 = col[2];
  Ball(float x, float y) {
    super(x, y);
  }

  void display() {
    ellipseMode(CENTER);
    fill(col[0], col[1], col[2]);
    ellipse(x, y, 50, 45);
    ellipse(x, y, 45, 50);
  }

  void move() {
    x += speedx;
    y += speedy;
    if (x > width) 
      speedx *= -1;
    if (x < 0) 
      speedx *= -1;
    if (y > height)
      speedy *= -1;
    if (y < 0) 
      speedy *= -1;
    for (Thing c : thingsToCollide) {
      if (isTouching(c) && this != c) {
        col[0] = 255;
        col[1] = 0;
        col[2] = 0;
      } else if (dist(x, y, c.x, c.y) > 500) {
        col[0] = og0;
        col[1] = og1;
        col[2] = og2;
      }
    }
  }
}

class Ball2 extends Ball implements Moveable {
  PImage img;
  Ball2(float x, float y, PImage image) {
    super(x, y);
    speedy = 0;
    img = image;
  }
  void display() {
    image(img, x, y, 50, 50);
  }
  void move() {
    x += speedx;
    y += speedy;
    if (x > width - 35) 
      speedx *= -.98;
    if (x < 0) 
      speedx *= -.98;
    if (y > height - 40) {
      speedy *= -.98;
    } else {
      speedy += 1.5;
    }
    for (Thing c : thingsToCollide) {
      if (isTouching(c) && this != c) {
        if ((x - c.x > 0 && speedx < 0) || (x - c.x < 0 && speedx > 0)) speedx *= -.98;
        speedy = (y - c.y) * (speedy / (dist(x, y, c.x, c.y)));
      }
    }
  }
}
/*DO NOT EDIT THE REST OF THIS */

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;
ArrayList<Thing> thingsToCollide;

void setup() {
  size(1000, 1000);
  PImage rock = loadImage("rock.png");
  PImage stone = loadImage("stone.png");
  PImage ball = loadImage("bball.png");

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  thingsToCollide = new ArrayList<Thing>();
  for (int i = 0; i < 5; i++) {
    Ball b = new Ball(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height-100), rock);
    thingsToDisplay.add(r);
    thingsToCollide.add(r);
  }
  for (int i = 0; i < 5; i++) {
    LivingRock m = new LivingRock(50+random(width-100), 50+random(height-100), stone);
    thingsToDisplay.add(m);
    thingsToMove.add(m);
    thingsToCollide.add(m);
    Ball2 b = new Ball2(50+random(width-100), 50+random(height-100), ball);
    thingsToDisplay.add(b);
    thingsToMove.add(b);
  }
}
void draw() {
  background(255);

  for (Displayable thing : thingsToDisplay) {
    thing.display();
  }
  for (Moveable thing : thingsToMove) {
    thing.move();
  }
}
