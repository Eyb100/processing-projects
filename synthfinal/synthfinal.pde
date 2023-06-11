import processing.sound.*;
WhiteNoise noise;
PinkNoise pnoise;

int sampleCount = 128;
float[] audio = new float[sampleCount];
float[] visualBuffer = new float[sampleCount];

AudioSample wave;
Sound s;

float volume = 1.0; 
//set initial rotation for first dial
float angle = 0; // Initial rotation angle
boolean rotateLeft = false;
boolean rotateRight = false;
// set initial rotation angle for the second dial
float angle2 = 0; 
boolean rotateLeft2 = false;
boolean rotateRight2 = false;

boolean redButtonPressed = false;
boolean greenButtonPressed = false;

void setup() {
  size(600, 400);
  noise = new WhiteNoise(this);
  pnoise = new PinkNoise(this);
  
  s = new Sound(this);
  s.volume(volume);

  wave = new AudioSample(this, audio, 440 * sampleCount);
  wave.loop();
}

void draw() {
  background(232, 219, 201);
  // Draw TV Stand
  fill(161, 108, 54);
  quad(120, 270, 500, 270, 600, 400, 0, 400);

  // Draw TV
  fill(124, 87, 61);
  rect(140, 70, 340, 220);
  fill(255);
  rect(140, 286, 340, 4);
  // silver edge
  rect(155, 85, 270, 190, 10);
  fill(0);
  // screen
  rect(170, 100, 240, 160, 28);
  // stand
  quad(140, 290, 145, 300, 475, 300, 480, 290);
  rect(175, 300, 270, 15);
  // control panel
  // dark grey
  fill(0);
  rect(430, 95, 45, 120);
  // volume dial
  fill(255);  
  ellipse(453, 170, 35, 35);  
  stroke(0);  
  // make the line on dial 2 rotate
  float x = 453 + 17.5 * cos(angle);
  float y = 170 + 17.5 * sin(angle);
  line(453, 170, x, y);
  // second dial
  fill(255);  
  ellipse(453, 118, 35, 35);  
  stroke(0);  
  // make the line on dial 1 rotate
  float x2 = 453 + 17.5 * cos(angle2);
  float y2 = 118 + 17.5 * sin(angle2);
  line(453, 118, x2, y2);
  // channel buttons
  if (redButtonPressed) {
    //light up when pressed
    fill(255, 0, 0); 
  } else {
    //transparent when not pressed
    fill(255, 0, 0, 100);
  }
  rect(438, 200, 15, 5);
  if (greenButtonPressed) {
    fill(0, 255, 0); 
  } else {
    fill(0, 255, 0, 100); 
  }
  rect(453, 200, 15, 5);

  noFill();
  stroke(255);

  // Define the rectangle coordinates
  float startX = 170;
  float startY = 100;
  float width = 240;
  float height = 160;

  // Generate the sine wave audio samples
  sineAudio();

  // Copy the audio samples to the visual buffer
  arrayCopy(audio, visualBuffer);

  // Loop through the waves vertically
  for (float yy = startY + height; yy >= startY; yy -= width / sampleCount) {
    beginShape();
    for (int i = 0; i < visualBuffer.length; i++) {
      float xx = map(i, 0, visualBuffer.length, startX, startX + width);
      float offsetY = map(visualBuffer[i], -1, 1, -width / sampleCount, width / sampleCount);
      vertex(xx, yy + offsetY);
    }
    endShape();
  }
//first dial rotation
  if (rotateLeft) {
    angle -= 0.01;  
  }

  if (rotateRight) {
    angle += 0.01;  
  }
//second dial rotation
  if (rotateLeft2) {
    angle2 -= 0.01;  
  }

  if (rotateRight2) {
    angle2 += 0.01;  
  }
//update volume
  s.volume(volume); 
  wave.write(audio);
}
//changing Timbre 
void mouseReleased() {
  if (mouseX >= 438 && mouseX <= 453 && mouseY >= 200 && mouseY <= 205) {
    redButtonPressed = !redButtonPressed; 
    //play white noise
    if (redButtonPressed) {
      noise.play(); 
    } else {
      //stop when pressed again
      noise.stop(); 
    }
  }

  if (mouseX >= 453 && mouseX <= 468 && mouseY >= 200 && mouseY <= 205) {
    greenButtonPressed = !greenButtonPressed; 
    if (greenButtonPressed) {
      //play pink noise
      pnoise.play(); 
    } else {
      //stop playing when pressed again
      pnoise.stop(); 
    }
  }
}
//volume dial down
void keyPressed() {
  if (key == '1') {
    rotateLeft = true;  
    quieter();  
  }
//volume dial up
  if (key == '2') {
    rotateRight = true; 
    louder();  
  }
//pitch dial down
  if (key == '3') {
    rotateLeft2 = true;   
    decreasePitch();  
  }
//pitch dial up
  if (key == '4') {
    rotateRight2 = true;  
    increasePitch();  
  }
}
//stop rotating left when key released
void keyReleased() {
  if (key == '1') {
    rotateLeft = false;  
  }
//and right
  if (key == '2') {
    rotateRight = false;  
  }

  if (key == '3') {
    rotateLeft2 = false;  
  }

  if (key == '4') {
    rotateRight2 = false;  
  }
}
// Multiply each audio element to decrease the pitch
void decreasePitch() {
  for (int i = 0; i < sampleCount; i++) {
    audio[i] *= 0.2; 
  }
}
// Multiply each audio element to increase the pitch
void increasePitch() {
  for (int i = 0; i < sampleCount; i++) {
    audio[i] *= 5; // Multiply each audio element by 1.1 to increase the pitch
  }
}

void clearAudio() {
  for (int i = 0; i < audio.length; i++) {
    audio[i] = 0;
  }
}
//add in audio
void sineAudio() {
  // Calculate the pitch adjustment factor based on the angle of the second dial
 float pitchFactor = pow(2, angle2); 
  for (int i = 0; i < sampleCount; i++) {
  // Apply the pitch adjustment to the sine wave generation
    audio[i] = sin(i / float(sampleCount) * TWO_PI * pitchFactor); 
  }
}



void quieter() {
  //half volume
  volume *= 0.5; 
  if (volume < 0.03125) {
    //set minimum volume
    volume = 0.03125;  
  }
}

void louder() {
  //double volume
  volume *= 2.0; 
  if (volume > 2.0) {
    //maximum volume
    volume = 2.0;  
  }
}
