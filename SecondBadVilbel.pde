/**
 * $Id: SecondBadVilbel.pde 27 2008-12-11 07:08:54Z btgiles $
 *
 * Copyright (C) 2008 Ben Giles
 * btgiles@gmail.com
 *
 * Released under the GPL, Version 3
 * License available here: http://www.gnu.org/licenses/gpl.txt
 */

import krister.Ess.*;

AudioChannel track;
int bufferSize;
int bufferDuration;
FFT myFFT;
int playPosition;

int fftSize = 512;
int fps = 1;

Palette palette;

PFont font;

void setup() {
  // this is the res of the DV video export at 16:9
  size(960, 540, P3D);

  // Ess setup
  Ess.start(this);
  //track = new AudioChannel("/Users/ben/bencode/Processing/SecondBadVilbel/sbv.mp3");
  track = new AudioChannel("/Users/ben/bencode/Processing/SecondBadVilbel/1234.mp3");
  bufferSize = track.buffer.length;
  bufferDuration = track.ms(bufferSize);

  myFFT = new FFT(fftSize);

  frameRate(fps);

  palette = new Palette();

  font = loadFont("CourierNew36.vlw");

  playPosition = 0;
}

void mousePressed() {
  if (track.state == Ess.PLAYING) {
    track.stop();
  }
  else {
    track.play(1);
  }
}

void draw() {
  background(0, 0, 255);

  textFont(font);

  playPosition = track.ms(track.cue);

  text(playPosition, 100, 400);

  drawSpectrum();
  drawSamples();
}

void drawSpectrum() {
  // line graph
  noStroke();

  myFFT.getSpectrum(track);

  for (int i = 0; i < fftSize / 2; i++) {
    //float temp = max(0, 185 - myFFT.spectrum[i] * 175);
    float temp = max(0, myFFT.spectrum[i] * 175);
    rect(i, temp + 0.5, 1, temp);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      track.cue(track.frames(playPosition - 500));
      println("skipping back");
    }
    if (keyCode == RIGHT) {
      track.cue(track.frames(playPosition + 500));
      println("skipping forward");
    }
  }
  if (key == 32) {
    if (track.state == Ess.PLAYING) {
      track.pause();
    }
    else {
      track.resume();
    }
  }
}

void drawSamples() {
  // osc
  stroke(255);

  // interpolate between 0 and writeSamplesSize over writeUpdateTime
  int interp=(int)max(0,(((millis()-track.bufferStartTime)/(float)bufferDuration)*bufferSize));

  for (int i=0;i<256;i++) {
    float left=100;
    float right=100;

    if (i+interp+1<track.buffer2.length) {
      left-=track.buffer2[i+interp]*75.0;
      right-=track.buffer2[i+1+interp]*75.0;
    }

    line(i,left,i+1,right);
  }
}

public void stop() {
  Ess.stop();
  super.stop();
}

