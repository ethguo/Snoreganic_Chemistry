Button grey, green, yellow, red;

String input = "";

void setup() {
  size(960, 540);
  background(#ffffff);

  fill(#333333);
  noStroke();

  rect(0, 0, width, height * 2 / 20);

  grey = new Button(height / 40, height / 40, #999999);
  grey.display();

  green = new Button(width - height * 9 / 40, height / 40, #80ff80);
  green.display();

  yellow = new Button(width - height * 3 / 20, height / 40, #ffff80);
  yellow.display();

  red = new Button(width - height * 3 / 40, height / 40, #ff8080);
  red.display();

  fill(#666666);
  stroke(#1a1a1a);

  rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

  fill(#ffffff);

  textAlign(CENTER, CENTER);
  textSize(14);

  text(input + "_", height / 10 + (width - height * 7 / 20) / 2, height / 20);
}

void draw() {
}

void keyPressed() {
  if (key == CODED) {
    //
  } else {
    if (key == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length() - 1);
      }
    } else if (key == ENTER) {
      //
    } else {
      input += key;
    }
  }

  background(#ffffff);

  fill(#333333);
  noStroke();

  rect(0, 0, width, height * 2 / 20);

  grey.display();

  fill(#666666);
  stroke(#1a1a1a);

  rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

  green.display();
  yellow.display();
  red.display();

  fill(#ffffff);

  textAlign(CENTER, CENTER);
  textSize(14);

  text(input + "_", height / 10 + (width - height * 7 / 20) / 2, height / 20);
}