/*
 * Base Example 
 *
 *   Sketch that features the basic building blocks of a Spacebrew client app.
 * 
 */

import spacebrew.*;



String server="sandbox.spacebrew.cc";
String name="Myriams App";
String description ="This is an blank example client that publishes .... and also listens to ...";
//incoming range var
int input=0;

//color c= color(0);
int incomingX=0;
int incomingY=0;
int incomingZ=40;
Glide rateValue;


//boolean drawCircle=false;

Spacebrew sb;

import beads.*; // import the beads library
AudioContext ac; // create our AudioContext
// declare our unit generators
WavePlayer modulator;
Glide modulatorFrequency;
WavePlayer carrier;
// our envelope and gain objects
Envelope gainEnvelope;
Gain synthGain;

void setup() {
  size(600, 400);

  // initialize our AudioContext
  ac = new AudioContext();
  // create the modulator, this WavePlayer will
  // control the frequency of the carrier
  modulatorFrequency = new Glide(ac, 9 - incomingZ);
  modulator = new WavePlayer(ac, 2000, 
  Buffer.SQUARE);
  // create a custom frequency modulation function
  Function frequencyModulation = new Function(modulator)
  {
    public float calculate() {
      // return x[0], scaled into an appropriate
      // frequency range
      return (x[0] * incomingZ) ;
    }
  };
  // create a second WavePlayer, control the frequency
  // with the function created above
  carrier = new WavePlayer(ac, frequencyModulation, 
  Buffer.SINE);
  // create the envelope object that will control the gain
  gainEnvelope = new Envelope(ac, 0);
  // create a Gain object, connect it to the gain envelope
  synthGain = new Gain(ac, 3, gainEnvelope);
  // connect the carrier to the Gain input
  synthGain.addInput(carrier);
  // connect the Gain output to the AudioContext
  ac.out.addInput(synthGain);
  ac.start(); // start audio processing
  


  // instantiate the sb variable
  sb = new Spacebrew( this );

  // add each thing you publish to
  //PARAMS: addPublish(name,type,default);
  //types: boolean,string,range
  //  sb.addPublish( "buttonPress", "boolean", false ); 
  sb.addPublish("mouseX", "range", 0);
  sb.addPublish("mouseY", "range", 0);
  sb.addPublish("mouseZ", "range", 0);
  //  sb.addPublish("mouseY", "range", 0);

  // add each thing you subscribe to
  // sb.addSubscribe( "color", "range" );
  //  sb.addSubscribe("buttonPress", "boolean");
  //  sb.addSubscribe("mouseMove", "boolean");
  sb.addSubscribe("x", "range");
  sb.addSubscribe("y", "range");
  sb.addSubscribe("z","range");

  // connect to spacebrew
  sb.connect(server, name, description );
}


/*
 * Here's the code to draw a scatterplot waveform.
 * The code draws the current buffer of audio across the
 * width of the window. To find out what a buffer of audio
 * is, read on.
 * 
 * Start with some spunky colors.
 */
//color fore = color(255, 102, 204);
//color back = color(0, 0, 0);

/*
 * Just do the work straight into Processing's draw() method.
 */


void draw() {
  // do whatever you want to do here
  background(100);

  modulatorFrequency.setValue(200);

//  if (true) {
//    println(input);
//    // println("incomingY = "+incomingY);
//    //this happens upon receipt of message
//
//    // ellipse(width/2, height/2, input, input);
//  }

 // when the mouse button is pressed,
    // add a 50ms attack segment to the envelope
    // and a 300 ms decay segment to the envelope
    
    map(incomingX, 0, 1024, 50, 80);
    map(incomingY, 0, 1024, 30, 50);
    
    gainEnvelope.addSegment(0.9, incomingX); // over 50ms rise to 0.8
    gainEnvelope.addSegment(0.0, incomingY); // in 300ms fall to 0.0
}

//
//void keyPressed() {
//  if (key=='s') {
//    sb.send("mouseX", mouseX);
//    // sb.send("mouseY", mouseY);
//    c=color(0);
//  }
//}
//
//void mouseDragged() {
//  sb.send("mouseX", mouseX);
//  // sb.send("mouseY", mouseY);
//  c=color(100);
////  println("mouseX");
//}
//
//void mousePressed() {
//  sb.send("buttonPress", true);
//}
//
//void mouseReleased() {
//  sb.send("buttonPress", false);
//}


void onRangeMessage( String name, int value ) {
  println("got range message " + name + " : " + value);
  if (name.equals("x")) {
    incomingX=value;
    //yellow
//    c=color(255, 255, 0);
    } else if (name.equals("y") ) {
     incomingY=value;
    }else if (name.equals("z") ) {
      incomingZ=value;
    }
}








