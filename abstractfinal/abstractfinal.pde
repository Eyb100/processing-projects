int[] colors = {
  color(242, 120, 48),  // orange
  color(242, 167, 75), // dusty orange
  color(242, 179, 61), // yorange
  color(247, 219, 109), // yellow
  color(121, 154, 197), // blue
  color(154, 188, 232), // light blue
  color(191, 153, 167), // grurple
  color(200, 198, 243), // lilac
  color(235, 156, 177), // dusty rose
  color(252, 158, 184), // pink
  color(255, 233, 207) // cream
};

PImage textureImage; 

void setup() {
  size(500, 500);
  stroke(255, 233, 207);
  strokeWeight(5);
  background(255);

  // Load the texture image for overlay
  textureImage = loadImage("texture.jpg");
  // Make transparent
  tint(255, 50); // Adjust the alpha value as desired
}

void draw() {
}

void mouseClicked() {
  pushMatrix();
  translate(mouseX, mouseY);
  for (int i = 0; i < 500; i++) {
    float size = random(50, 500);
    //add random noise values
    float noiseX = random(100); 
    float noiseY = random(100);
    float noiseVal = noise(noiseX, noiseY); 

    fill(colors[int(random(colors.length))]);
    int shapeSelector = int(random(1, 4));
    if (shapeSelector == 1) {
      spiral(size * noiseVal, 0.02, 0.07);
    } else if (shapeSelector == 2) {
      clover(random(-250, 250), random(-250, 250), size * noiseVal);
    } else {
      flower(random(-250, 250), random(-250, 250), size * noiseVal);
    }
  }
  popMatrix();
  
   pushMatrix();
  translate(0,0);
   //Draw the texture image on the background
  image(textureImage, 0, 0, width, height);
}
//flower shape
void flower(float x, float y, float size) {
  int petalCount = 5;
  float petalSize = size;
  float petalAngle = TWO_PI / petalCount;
  for (int i = 0; i < petalCount; i++) {
    pushMatrix();
    rotate(i * petalAngle);
    fill(250, 200, 200);
    ellipse(0, 0, petalSize, petalSize / 2);
    popMatrix();
  }
}
//3 petal shape
void clover(float x, float y, float size) {
  beginShape();
  for (float angle = 0; angle <= TWO_PI; angle += TWO_PI / 3) {
    float cx = x + cos(angle) * 5; 
    float cy = y + sin(angle) * 5; 
    curveVertex(cx, cy);
    cx = x + cos(angle + TWO_PI / 3) * size * 10; 
    cy = y + sin(angle + TWO_PI / 3) * size * 10; 
    curveVertex(cx, cy);
  }
  endShape(CLOSE); 
}
//spiral shape
void spiral(float radius, float angleIncrement, float radiusIncrement) {
  beginShape();
  float angle = 0.2;
  for (int i = 0; i < 800; i++) {
    float x = radius * cos(angle);
    float y = radius * sin(angle);
    vertex(x, y);
    angle += angleIncrement;
    radius += radiusIncrement;
  }
  endShape();
}
