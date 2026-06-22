/*
Auther Name:
# Po Tek (220249220),
# Uchhit Karmacharya(220259903),
# Rajib Barua(220252747),
# Krishkumar Patel(220257881)
Project: Missile Command
Unit: COSC101

Purpose of the program: This program starts with the draw loop function to show files in the screen window.
                      The main purpose of the game is to make sure the player is able to protect the city
                      by shooting the missile with weapon. The player also needs need save the cityin order
                      to win the game.

Description: The game's principle is simple: there are six towns at the bottom of the screen that are attacked
           by missiles descending from the top of the screen at random. The player commands an anti-missile battery
           that launches counter-missiles to intercept and destroy the incoming ballistic missiles. The player directs
           the mouse pointer to the point where the counter-missile will detonate, and when the counter-missile arrives,
           with the help of anti missil it bursts.
                   
*/
//import processing.sound.*;
//SoundFile[] file = new SoundFile[3];  //importing the sound file
int[] missiles, battery;              // creating the anti missile and battery
PShape sh;                            // storing the shape
int[] shot_x, shot_y;                 // creating the moving of anti missile
int shotSpeed;                        // anti missile speed
float[] building_pos_x, building_pos_y; // creating postion of the building
float counter_missiles_width, counter_missiles_height;      // counter missile size
float[] anti_missiles_x, anti_missiles_y;                    // anti missiles position
int[] ballis_mis_x, ballis_mis_current_x, ballis_mis_current_y;  // ballistic missile positon
float[] ballis_mis_degree;                                   // the ballistic missile angle
int level,total_missiles, ballis_missile_speed, missile_at_once, score;  // creating level,total_missiles, ballis_missile_speed, missile_at_once, score
int[] explosion_x,explosion_y,radius,add_minus;              // postion of the explosion
int max_radius;                                              // size of explosion
PImage win,loose;                                            // win and loose imgage
boolean start;



//Startup - assigning values to the variables
void setup(){
  size(800, 800); //all code is flexible to this size of the screen
  noStroke();
   win = loadImage("assets/win.png"); //load win image to win variable
  loose = loadImage("assets/loose.jpg");
  //loading image for the files
//  file[0] = new SoundFile(this, "startGame.mp3");
//  file[1] = new SoundFile(this, "LevelUp.mp3");
//  file[2] = new SoundFile(this, "boom.mp3");


  //float[] battery = new float[2];
  missiles = new int[10];
  battery = new int[2];
  shot_x = new int[0];
  shot_y = new int[0];
  shotSpeed = 50;
  counter_missiles_width = width*0.03;
  counter_missiles_height = height*0.01;
  anti_missiles_x = new float[0];
  anti_missiles_y = new float[0];

  building_pos_x = new float[0];
  building_pos_y = new float[0];
  //adding x and y positions for buildings
  for(int i=1; i<4; i++){
  building_pos_x = append(building_pos_x, (width*(0.07*i+0.02*i)));
  building_pos_x = append(building_pos_x, (width*(0.64+0.07*(i-1)+0.02*i)));
  building_pos_y = append(building_pos_y, height*0.85);
  building_pos_y = append(building_pos_y, height*0.85);
  }
  //assining arrays for the ballis_missiles
  ballis_mis_x = new int[0];
  ballis_mis_degree = new float[0];
  ballis_mis_current_x = new int[0];
  ballis_mis_current_y = new int[0];
  
  //start of level one
  level = 1;
  total_missiles = 12;//no of missiles in each level
  ballis_missile_speed = 1;
  missile_at_once = 4;
  score = 0;
 
  explosion_x = new int[0];
  explosion_y = new int[0];
  radius = new int[0];
  add_minus = new int[0];
  max_radius = 75;
  
  start = false;//used to pause the game after loose or win 
  //file[0].play();//play sound for file
  //file[0].loop();

  create_missiles(1);//starts by firing one missile
}
//draw the green moving anti_weapon
void anti_weapon(){
  fill(0,220,0);
  rect(mouseX, height*0.83, width*0.04, height*0.02);//size
}
//the function returns the float degree that the basistic missile will drop at
float ballis_cal_degree(float x){
  float min_degree = atan((width-x)/height);//calculating the min and max degree
  float max_degree = atan(x/height);
  float degree = random(90-degrees(min_degree), 90+degrees(max_degree));
  return degree;
}

//city displays
void buildings(){
  fill(33, 140, 222);
  for(int i=0; i<building_pos_x.length; i++){
  if(building_pos_y[i] == height*0.85){
  rect(building_pos_x[i], building_pos_y[i], width*0.07, height*0.05);
  }else{
  rect(building_pos_x[i], building_pos_y[i], width*0.07, height*0.01);
  }
  }
  noFill();
}
//ground display(all brown areas)
void ground(){
  fill(99, 55, 55);
  // following two lines of code creates the side mountains and they are 15% high and 7% wide.
  rect(0,height-(height*0.15), width*0.07, height*0.15);
  rect(width-(width*0.07),height-(height*0.15), width*0.07, height*0.15);
  rect(width*0.07, height-(height*0.10), width-(width*0.14), height*0.10);
  float y_mountain_pos = 4;
  float mountain_width = 2;
  for(int i=0; i<3; i++){
  rect(width/2, height-(height*(0.10+0.05/y_mountain_pos)), width*(0.07*mountain_width), height*(0.05));
  rect(width/2, height-(height*(0.10+0.05/y_mountain_pos)), width*(0.07*mountain_width)*-1, height*(0.05));
  y_mountain_pos /= 2;
  mountain_width /= 2;
  }
  noFill();
}
//moves the antimissile(green missile) vertically
void moveShot(){
  for(int i=0;i<shot_x.length;i++){
  fill(0,220,0);
  rect(shot_x[i],shot_y[i],5,25);
  shot_y[i]-=shotSpeed;
  }
}
//alculates the initial position of anti_missiles and battery. calls the function that creates the shape.
void count_missiles(){
  fill(0);
  for(int i = 0; i < battery.length; i++){
  if(battery[i] == 0){
    anti_missile(width*(0.07+i*(counter_missiles_width*2/width+0.02)), height-height*0.08, counter_missiles_width*2, counter_missiles_height*2);
  }
  }
  float start_x = width/2-(width*0.015);
  float start_y = height-height*0.08;
  for(int i = 0; i < missiles.length; i++){
  if(missiles[i] == 0){
  if(i == 1){
    start_x -= width*(0.03*3);
    start_y += height*0.01;
  }else if(i == 3){
    start_x -= width*(0.03*5);
    start_y += height*0.01;
  }else if(i == 6){
    start_x -= width*(0.03*7);
    start_y += height*0.01;
  }
  anti_missile(start_x, start_y, counter_missiles_width, counter_missiles_height);
  start_x += width*(0.03*2);
  }else{
    break;
  }
  }
}
//displays the shape of the antimissile
void anti_missile(float x, float y, float rect_width, float rect_height) {
  rect(x, y, rect_width, rect_height);
}
//calculates the position of the missiles(ballistic missiles)
void create_missiles(int num){
  println("num "+num);
  for(int i=0; i<num; i++){
  ballis_mis_x = append(ballis_mis_x, round(random(width*0.1, width*0.9)));
  float degree = ballis_cal_degree(ballis_mis_x[ballis_mis_x.length-1]);
  ballis_mis_degree = append(ballis_mis_degree, radians(degree));
  ballis_mis_current_x = append(ballis_mis_current_x, ballis_mis_x[ballis_mis_x.length-1]);
  ballis_mis_current_y = append(ballis_mis_current_y, 0);
  total_missiles -= 1;
  }
 if(total_missiles == 0 && ballis_mis_current_x.length == 0){//this statement increases the level
  //file[1].play();
  level += 1;
  start = false;
  increment_score();
  missiles = new int[10];
  battery = new int[2];
  if(level <= 6){
    total_missiles = 9 + level*3;//total no of missile in any given level
    ballis_missile_speed += 1;//added speed for the missile
  }
  }
}
//calculate the missiles remaining on the stockpile
void mouseReleased(){  
  if(missiles[0] != 1){
  for(int i = 1; i < missiles.length; i++){
    if(missiles[i] == 1){
      missiles[i-1] = 1;
      break;
    }
  }
  if(missiles[missiles.length-1] == 0){
      missiles[missiles.length-1] = 1;
    }
  }
}

//the ballistic missiles falling towards the city and their shape
void rain_ballis(){
  stroke(100);
  strokeWeight(10);
  for(int i = 0; i<ballis_mis_x.length; i++){
  beginShape(TRIANGLES);
  vertex(ballis_mis_current_x[i]-5, ballis_mis_current_y[i]-20);
  vertex(ballis_mis_current_x[i], ballis_mis_current_y[i]);
  vertex(ballis_mis_current_x[i]+5, ballis_mis_current_y[i]-20);
  endShape();
  ballis_mis_current_y[i] += ballis_missile_speed;
  ballis_mis_current_x[i] = ballis_mis_x[i]+round(ballis_mis_current_y[i]/tan(ballis_mis_degree[i]));
  }
  noStroke();
}

//this function takes 2 parameters (name of the array and an index). The function removes the value in the index from the  
// array.
//https://stackoverflow.com/questions/2459780/best-way-to-remove-an-object-from-an-array-in-processing(reference)
int[] int_remove_object_array(int[] array, int index){
  int index2 = array.length-1;
  int old = array[index];
  array[index] = array[index2];
  array[index2] = old;
  array = shorten(array);
  return array;
}
//this function is similar to the top one but this return the array in float datatype
float[] int_remove_object_array(float[] array, int index){
  int index2 = array.length-1;
  float old = array[index];
  array[index] = array[index2];
  array[index2] = old;
  array = shorten(array);
  return array;
}
//function is run when they win and displays an image
void win(){
  pause_game();
  image(win, width/2-win.width/2, 10);
  start = true;
  noLoop();
}
//the function displays the loose image
void loose(){
  pause_game();
  image(loose, width/2-loose.width/2, 10);
  start = true;
  noLoop(); //stops looping until user enter spacebar
}

//runs continuesly and check if user win or loose
void game_end_win_loose(){
  if(missiles[0] == 1 && total_missiles != 0){
  loose();
  }else if(score >= 3930 ){
  win();
  }
  int count = 0;
  for(int i = 0;i<building_pos_x.length;i++){
  if (building_pos_y[i] == height*0.89){
    count += 1;
  }
  }
  if (count == 6){
  loose();
  }
}

//calculates the collision between ballistic missiles and buildings, ballistic missiles and ground.
boolean collision_detect(){
 
  for(int mis=0; mis<ballis_mis_x.length; mis++){
    for(int build=0; build<building_pos_x.length; build++){
      if(ballis_mis_current_x[mis] >= building_pos_x[build] && ballis_mis_current_x[mis] <=
      (building_pos_x[build]+width*0.07) && ballis_mis_current_y[mis] >= building_pos_y[build] && ballis_mis_current_y[mis] <= height*0.9){
        building_pos_y[build] = height*0.89;
        blowing_ballis_missile(mis);
        return true;
      }
    }
    if(ballis_mis_current_y[mis] >= height*0.85){
      if(ballis_mis_current_x[mis]>=width*0.465 && ballis_mis_current_x[mis] <=width*0.535){   
        blowing_ballis_missile(mis);
        return true;
      }else if(ballis_mis_current_x[mis] >= width*0.93 && ballis_mis_current_x[mis] <= width){
        blowing_ballis_missile(mis);
        return true;
      }else if(ballis_mis_current_x[mis] >= 0 && ballis_mis_current_x[mis]<=width*0.07){
        blowing_ballis_missile(mis);
        return true;
      }
    }
    if(ballis_mis_current_y[mis] >= height*0.875 && ballis_mis_current_x[mis] >= width*0.47
    && ballis_mis_current_x[mis] <= width*0.57){
      blowing_ballis_missile(mis);
      return true;
    }
    if(ballis_mis_current_y[mis] >= height*0.8875 && ballis_mis_current_x[mis] >= width*0.36
    && ballis_mis_current_x[mis] <= 0.64){
      blowing_ballis_missile(mis);
      return true;
    }
    if(ballis_mis_current_y[mis] >= height*0.9){
      blowing_ballis_missile(mis);
      return true;
    }
  }
    
  for(int i= 0; i<shot_x.length; i++){
  }
  return false;
}

//removes the ballistic missile from the screen after collision
void blowing_ballis_missile(int mis){
  ballis_mis_x = int_remove_object_array(ballis_mis_x, mis);
  ballis_mis_current_x = int_remove_object_array(ballis_mis_current_x, mis);
  ballis_mis_current_y = int_remove_object_array(ballis_mis_current_y, mis);
  ballis_mis_degree = int_remove_object_array(ballis_mis_degree, mis);
}

//creates the anti missile via creating the coordinates
void mousePressed() {
  if(missiles[0] != 1){
  shot_x = append(shot_x, mouseX);
  shot_y = append(shot_y, int(height*0.83));
  }  
}

// calculation between ballistic missiles and anti-missiles
boolean collisionDetection(){
  for(int i=0;i<ballis_mis_current_x.length;i++){
  for(int j=0;j<shot_x.length;j++){
    if((shot_x[j]+5)>=ballis_mis_current_x[i] && shot_x[j]<=(ballis_mis_current_x[i]+50) &&
    (shot_y[j]+5)>=ballis_mis_current_y[i] && shot_y[j]<=(ballis_mis_current_y[i]+50)){
     shot_x = int_remove_object_array(shot_x, j);
      shot_y = int_remove_object_array(shot_y, j);
    explosion_x = append(explosion_x, ballis_mis_current_x[i]);
   explosion_y = append(explosion_y, ballis_mis_current_y[i]);
   radius = append(radius, 1);
   add_minus = append(add_minus, 1);
   blowing_ballis_missile(i);
   score += 25;
//   file[2].play();
   return true;
    }
  }
  }
  return false;
}

//increments score from all points.
void increment_score(){
  frameRate(1);
  for(int i=0; i<building_pos_x.length; i++){
  if(building_pos_y[i] == height*0.85){
    score+=100;
  }
  }
  int value = 0;
  for(int i=0; i<battery.length; i++){
  if(value != 0){
    score += 10*5;
  }else if(battery[i] == 0){
    for(int mis=0; mis<missiles.length; mis++){
      if(missiles[mis] == 0){
        score += 5;
        missiles[mis] = 1;
        value++;
      }
    }
  }
  }
  if(start == true){
    pause_game();
  }
}

//pause the game. displays a new screen and the image. and also noLoop
void pause_game(){
  background(130,205,255);
  //crosshair();
  textSize(43);
  textAlign(CENTER);
  fill(38,81,125);
  text("Missile Command",width/2,(height/2)-10);
  textSize(12);
  text("Press Spacebar to Continue!",width/2,(height/2)+10);
  noLoop();
}

//keypress will start looping
void keyPressed(){
  loop();
}

//circile explosion
void explosion(){
  for(int i = 0; i<explosion_x.length; i++){
  fill(random(255),random(255),random(255));
  ellipse(explosion_x[i], explosion_y[i], radius[i], radius[i]);
  if(radius[i] == 0){
    explosion_x = int_remove_object_array(explosion_x, i);
    explosion_y = int_remove_object_array(explosion_y, i);
    radius = int_remove_object_array(radius, i);
    add_minus = int_remove_object_array(add_minus, i);
  }else if (radius[i] == max_radius){
    add_minus[i] = -1;
    radius[i] += add_minus[i];
  }else{
    radius[i] += add_minus[i];
  }
  }
  noFill();
}
//Draw() fucntion is being used for running in the program
void draw(){
  frameRate(40);
  background(random(50));
  if(start == true){
    setup();
  }else{
    start = false;
  }
  ground();
  buildings();
  fill(217, 215, 210);
  anti_missile(mouseX-counter_missiles_width/2,mouseY-counter_missiles_height/2,  counter_missiles_width, counter_missiles_height);
  noFill();

  rain_ballis();
  count_missiles();
  boolean collision = collision_detect();
  if((collision || ballis_mis_x.length == 0) && ballis_mis_x.length<missile_at_once){
  if(total_missiles >= missile_at_once){
    create_missiles(int(random(0,missile_at_once+1-ballis_mis_x.length)));
  }else{
    create_missiles(int(random(0,total_missiles+1-ballis_mis_x.length)));
  }
  }
  explosion();
  anti_weapon();
  //shape(sh,mouseX,height*0.85);
  moveShot();
  fill(255);
  textSize(20);
  text("Level "+level, width*0.05, height*0.02);
  textSize(50);
  text(score, width/2, height*0.05);
  if(missiles[0] == 1){
  for(int i = 0; i < battery.length; i++){
      if(battery[i] == 0) {
        missiles = new int[10];
        battery[i] = 1;
        break;
      }
  }
  }
  collision = collisionDetection();
  game_end_win_loose();

  // if(start==false){
  
  //}
}
