import peasy.*;
import controlP5.*;

int DIM = 50;
PeasyCam cam;
ArrayList<PVector> mandelbulb = new ArrayList<PVector>();
ControlP5 cp5;

float hueValue= 150; //initial hue value
int chaos = 4;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 600);
  cp5= new ControlP5(this);
  
  generateMandelbulb();
  // Add a slider to control hue
  //cp5.addSlider("hueValue")
     //.setPosition(20, 20);
     //.setRange(0, 255) // Range of the slider
     //.setValue(150)    // Initial value
    //.setWidth(200);   // Width of the slider

 
}

void generateMandelbulb(){
  //changes form- keep between 4-64 (4 dispersed but formed, 64, most solid)

   StringList points = new StringList();
   mandelbulb = new ArrayList<PVector>();

  for (int i = 0; i < DIM; i++) {
    for (int j = 0; j < DIM; j++) {
      boolean edge = false;
      for (int k = 0; k < DIM; k++) {
        float x = map(i, 0, DIM, -1, 1);
        float y = map(j, 0, DIM, -1, 1);
        float z = map(k, 0, DIM, -1, 1);
        PVector zeta = new PVector(0, 0, 0);
        int maxiterations = 10;
        int iteration = 0;
        while (true) {
          Spherical c = spherical(zeta.x, zeta.y, zeta.z);
          float newx = pow(c.r, chaos) * sin(c.theta*chaos) * cos(c.phi*chaos);
          float newy = pow(c.r, chaos) * sin(c.theta*chaos) * sin(c.phi*chaos);
          float newz = pow(c.r, chaos) * cos(c.theta*chaos);
          zeta.x = newx + x;
          zeta.y = newy + y;
          zeta.z = newz + z;
          iteration++;
          if (c.r > 2) {
              edge = false;
            break;
          }
          if (iteration > maxiterations) {
            if (!edge) {
              edge = true;
              mandelbulb.add(new PVector(x, y, z));
            }
            break;
          }
        }
      }
    }
  }
  
  String[] output = new String[mandelbulb.size()];
  for (int i = 0; i < output.length; i++) {
    PVector v = mandelbulb.get(i);
    output[i] = v.x + " " + v.y + " " + v.z;
  }
  saveStrings("mandelbulb.txt", output);
  
  
}

class Spherical {
  float r, theta, phi;
  Spherical(float r, float theta, float phi) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
  }
}

Spherical spherical(float x, float y, float z) {
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x+y*y), z);
  float phi = atan2(y, x);
  return new Spherical(r, theta, phi);
}

void draw() {
  background(0);
  rotateX(PI/4);
  rotateY(-PI/3);
  colorMode(HSB, 255); //colour change
  //rotation 
  float angle = millis() * 0.001;
  rotateY(angle);
  
  stroke(hueValue, 255, 255);
  
  for (PVector v : mandelbulb) {
    //stroke(200, 200, 255); //COLOUR CHANGE between 1-255- HUE SATURATION BRIGHTNESS
    strokeWeight(2);
    point(v.x*200, v.y*200, v.z*200);
  }
}
void hueValue(float val) {
  hueValue = val; // slider value change for hue
}


void keyPressed() {
  if (key == '+') {
    chaos += 5; // Increment by 5
    chaos = constrain(chaos, 4, 64); // Ensure n stays within the range of 4 to 64
    println("n is now: " + chaos);
    generateMandelbulb(); // Regenerate mandelbulb when n changes
  } else if (key == '-') {
    chaos -= 5; // Decrement by 5
    chaos = constrain(chaos, 4, 64); // Ensure n stays within the range of 4 to 64
    println("n is now: " + chaos);
    generateMandelbulb(); // Regenerate mandelbulb when n changes
  }
}
