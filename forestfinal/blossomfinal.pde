PImage petalImage1; 
PImage petalImage2; 
PImage petalImage3; 
PImage backgroundImage;
float petalSize = 20; 

// Petal class
class Petal {
  PVector position;
  PVector velocity;
  float rotationSpeed;
  float angle;
  PImage image;
  boolean landed;
  int pileTimer;

  Petal(PImage img) {
    // Randomize position, falling velocity, and rotation
    position = new PVector(random(width), random(-height, 0));
    velocity = new PVector(0, random(1, 3)); 
    rotationSpeed = random(-0.1, 0.1); 
    angle = 0; 
    image = img; 
    //petals begin in air
    landed = false; 
    pileTimer = 0;
  }

  void update() {
    if (!landed) {
      //add gravity
      position.add(velocity); 
      //add rotation
      angle += rotationSpeed; 

//if petal lands,stop falling and roating,mark as landed
      if (position.y >= height - petalSize / 2) {
        position.y = height - petalSize / 2;
        velocity.set(0, 0); 
        rotationSpeed = 0;
        landed = true;
//start timer when petals hit ground
        pileTimer = millis(); 
      }
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    image(image, -petalSize / 2, -petalSize / 2, petalSize, petalSize);
    popMatrix();
  }
}

// ArrayList for falling petals
ArrayList<Petal> fallingPetals = new ArrayList<Petal>();
int numPetals = 1000; 

void setup() {
  size(800, 600); 
  petalImage1 = loadImage("blossom1.png");
  petalImage2 = loadImage("blossom2.png"); 
  petalImage3 = loadImage("blossom3.png"); 
  backgroundImage = loadImage("backgroundblossom.jpg"); 

  // Create petal objects
  for (int i = 0; i < numPetals; i++) {
    // switch between different petal images
    if (i % 3 == 0) {
      fallingPetals.add(new Petal(petalImage1));
    } else if (i % 3 == 1) {
      fallingPetals.add(new Petal(petalImage2));
    } else {
      fallingPetals.add(new Petal(petalImage3));
    }
  }
}

void draw() {
  background(0);
  // Draw the background at specific coordinates
  image(backgroundImage, -100, -200); 

  // Update and display petals
  for (Petal petal : fallingPetals) {
    petal.update();
    petal.display();
  }

  // make pile at the bottom 
  for (int i = fallingPetals.size() - 1; i >= 0; i--) {
    Petal petal = fallingPetals.get(i);
    if (petal.landed) {
      //remove petals from arraylist after certain time
      if (millis() - petal.pileTimer > 5000) {
        fallingPetals.remove(i);
      }
    }
  }

  // constantly generate new petals to replace them
  int numNewPetals = numPetals - fallingPetals.size();
  for (int i = 0; i < numNewPetals; i++) {
    if (i % 3 == 0) {
      fallingPetals.add(new Petal(petalImage1));
    } else if (i % 3 == 1) {
      fallingPetals.add(new Petal(petalImage2));
    } else {
      fallingPetals.add(new Petal(petalImage3));
    }
  }

  petalPile();
}

// Gather landed petals at the bottom
void petalPile() {
  float pileX = width / 2; 
  float pileY = height - petalSize / 2;
  
}
//make wind
void keyPressed() {
  //left when left arrow pressed
  if (keyCode == LEFT) {
    for (Petal petal : fallingPetals) {
      if (!petal.landed) {
        //wind left
        petal.velocity.x = -1; 
      }
    }
  //right when right arrow pressed
  } else if (keyCode == RIGHT) {
    for (Petal petal : fallingPetals) {
      if (!petal.landed) {
        //wind right
        petal.velocity.x = 1; 
      }
    }
  }
}

void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    for (Petal petal : fallingPetals) {
      if (!petal.landed) {
        //no wind
        petal.velocity.x = 0; 
      }
    }
  }
}
