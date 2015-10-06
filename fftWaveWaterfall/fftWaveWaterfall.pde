import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioInput  input;
FFT         fft;

// settings
int fftsize = 0; // these two set after fft is initialized
float minfftscale = 1;
color[] bandcolor = { // first is low freq
  color(255,64,0),
  color(255,128,0),
  color(255,192,0),
  color(255,255,0),
  color(192,255,0),
  color(128,255,0),
  color(64,255,0),
  color(0,255,0)
};
int numbands = bandcolor.length;

// global variables
float fftscale = 30;

void setup() {
  size(displayWidth,displayHeight);
  
  minim = new Minim(this);
  input = minim.getLineIn();
  fft = new FFT(input.bufferSize(),input.sampleRate());
  fftsize = fft.specSize()/2; // chop off top half
  
  background(0);
  
}

void draw() {
  fft.forward(input.mix);
  
  // calculate bands
  float bands[] = new float[numbands];
  float cbands[] = new float[numbands];
  
  int highband = fftsize*2;
  int lowband = highband/2;
  int iband = numbands;
  // logarithmic band split
  while (iband >= 0) {
    iband--;
    highband = lowband-1;
    lowband /= 2;
    if (iband < 1) lowband = 0;
    for (int i = highband; i > lowband; i--) {
      bands[iband] += fft.getBand(i);
    }
  }
  //cumulative bands
  cbands[0] = bands[0];
  for (int i = 1; i < numbands; i++) {
    cbands[i] = cbands[i-1] + bands[i];
  }
  
  // do the calc for fft scale
  /*float maxfft = cbands[numbands-1];
  if (maxfft > fftscale) fftscale = maxfft;
  if (fftscale > minfftscale) fftscale *= 0.99;*/
  if (mousePressed) fftscale = map(mouseX,0,width,minfftscale,100);
  
  noStroke();
  fill(0);
  //clear the fft graph 
  rect(0,0,width,2);
  
  // draw the faint lines
  stroke(64);
  for (int i = 0; i < fftscale; i++) {
    float a = (width/2) - map(i,0,fftscale,0,width/2);
    line(a,0,a,1);
    line(width-a,0,width-a,1);
  }
  
  
  // now draw the waveform part
  
  for (int b = 0; b < numbands; b++) {
    float start = 0;
    if (b!=0) start = map(cbands[b-1],0,fftscale,0,width/2);
    float end = map(cbands[b],0,fftscale,0,width/2);
    stroke(bandcolor[b]);
    line(width/2+start,1,width/2+end,1);
    line(width/2-start,1,width/2-end,1);
  }
  
  // shift waveform down
  loadPixels();
  for (int i = width*(height-1)-1; i > width; i--) {
    pixels[i+width] = pixels[i];
  }
  updatePixels();
}

boolean sketchFullScreen() { return true; }
  
