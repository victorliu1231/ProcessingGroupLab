interface Displayable {
  void display();
}

interface Moveable {
  void move();
}

abstract class Thing implements Displayable {
  float x, y;//Position of the Thing

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
  abstract void display();
}

class Rock extends Thing {
  PImage rock = loadImage("rock.png");
  Rock(float x, float y) {
    super(x, y);
  }

  void display() {
    image(rock, x, y, 50, 50);
  }
}

public class LivingRock extends Rock implements Moveable {
  int[] path1X = new int[]{10, 10, 0, -10, -10, -10, 0, 10};
  int[] path1Y = new int[]{0, -10, -10, -10, 0, 10, 10, 10};
  int counter = 0;
  LivingRock(float x, float y) {
    super(x, y);
  }
  void move() {
    int xIncr = path1X[counter];
    int yIncr = path1Y[counter];
    if (x >= width) {
      xIncr *= -1;
    } else if (x <= 0) {
      xIncr *= 1;
    }
    if (y >= height) {
      yIncr *= -1;
    } else if (y <= 0) {
      yIncr *= 1;
    }
    x += xIncr;
    y += yIncr;
    if (counter == 7){
      counter = 0;
    } else {
      counter++;
    }
  }
}

class Ball extends Thing implements Moveable {
  float[] col = {random(255), random(255), random(255)};
  String val = "";
  Ball(float x, float y) {

    super(x, y);
  }

  void display() {
    if (val.equals("Simple")) {
      ellipseMode(CENTER);
      fill(col[0], col[1], col[2]);
      ellipse(x, y, 50, 45);
      ellipse(x, y, 45, 50);
    }
    if (val.equals("Image")) {
      image(loadImage("bball.png"), x, y, 50, 50);
    }
  }

  void move() {
    float xinc = random(5);
    float yinc = random(5);
    if (x > width) 
      xinc *= -1;
    if (x < 0) 
      xinc *= -1;
    if (y > height) 
      yinc *= -1;
    if (y < 0) 
      yinc *= -1;
    x += xinc;
    y += yinc;
  }
}

/*DO NOT EDIT THE REST OF THIS */

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;

void setup() {
  size(1000, 800);

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  for (int i = 0; i < 10; i++) {
    Ball b = new Ball(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(r);
  }
  for (int i = 0; i < 3; i++) {
    LivingRock m = new LivingRock(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(m);
    thingsToMove.add(m);
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