void environment()
{
  hud();

  if (switches[2].onOff) cameras(2);  // Switch between views
  else if (switches[3].onOff)cameras(3);
  else cameras(0);
}

//---> Function for cameras.
void cameras(int num)
{
  switch(num)
  {
  case 0:
    lights();
    if (keyPressed)
    {
      if (key==CODED) if (keyCode==SHIFT)
      {
        x1=mouseX;
        y1=mouseY;
        switches[2].onOff=false;
        switches[3].onOff=false;
      }
    }

    //---> Camera Manipulation
    float a=cos(radians(x1*360/width))*sin(radians(y1*180/width))*radius;
    float b=sin(radians(x1*360/width))*sin(radians(y1*180/width))*radius;
    float c=cos(radians(y1*180/width))*radius;
    camera(a/zoom+width/2, b/zoom-height/2, (c)/zoom+height/2, width/2, -height/2, height/2, 0.0, 0.0, -1);
    //<---
    break;
  case 1:
    noLights();
    camera();

    break;

  case 2:
    lights();
    if (keyPressed)
    {
      if (key==CODED) if (keyCode==SHIFT)
      {
        switches[2].onOff=false;
        switches[3].onOff=false;
      }
    }

    camera(width/2, -height/2, height, width/2, -height/2-1, 0, 0, 0, -1);
    break;

  case 3:
    lights();
    if (keyPressed)
    {
      if (key==CODED) if (keyCode==SHIFT)
      {
        switches[2].onOff=false;
        switches[3].onOff=false;
      }
    }
    camera(width/2, height/2, height/6, width/2, -height/2, height/6, 0.0, 0.0, -1);
    break;
  }
}


void attractorMan()
{
  cameras(1);
  stroke(0.6);
  pushMatrix();
  {
    translate(width/10, height/10);
    rect(20, 25, width/5, height/5, 5);
    fill(0.3);
  }
  popMatrix();

  circX= map(att.x, width, 0, 0, width/5);
  circY= map(att.y, 0, -height, 0, height/5);
  circZ= map(att.z, 0, height, 0, height/5);

  fill(0.3);
  line(40+width/5, 25, 40+width/5, height/5+25);

  pushMatrix();
  {
    translate(circX, circY, 0);
    ellipse(20, 20, 10, 10);
  }
  popMatrix();


  pushMatrix();
  {
    translate(40+width/5, circZ, 0);
    ellipse(0, 0, 10, 10);
  }
  popMatrix();
}



void mouseDragged()
{
  for (int i=0; i<ctrl_pts.length; i++)
  {
    for (int j=0; j<ctrl_pts.length; j++)
    {
      PVector screenPos=new PVector();
      screenPos.x= screenX(ctrl_pts[i][j].x, ctrl_pts[i][j].y, ctrl_pts[i][j].z);
      screenPos.y= screenY(ctrl_pts[i][j].x, ctrl_pts[i][j].y, ctrl_pts[i][j].z);


      if (mouseX<screenPos.x+2.5 &&
        mouseX>screenPos.x-2.5 &&
        mouseY<screenPos.y+2.5 &&
        mouseY>screenPos.y-2.5)
      {
        float changeX= mouseX;
        float changeY= mouseY;


        ctrl_pts[i][j].x+=changeX-mouseX;
        ctrl_pts[i][j].y+=changeY-mouseY;
      }
    }
  }
  if (mouseX<circX+20+35 &&
    mouseX>circX+20-35 &&
    mouseY<circY+20+35 &&
    mouseY>circY+20-35)
  {
    att.x=map(mouseX-20, width/5, 0, 0, width);
    att.y=map(mouseY-20, 0, -height/5, 0, height);
  }

  if (mouseX<40+width/5+35 &&
    mouseX>40+width/5-35 &&
    mouseY<circZ+20+65 &&
    mouseY>circZ+20-65)
  {
    att.z=map(mouseY, 0, height/5, 0, height);
  }

  if (mouseButton == RIGHT) 
  {
    radius=mouseY-width/200;
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    seed++;
    makeCtrlPts();
  }
}


void hud()
{
  cameras(1);
  attractorMan();

  fill(0.9);
  noFill();

  for (int i=0; i< switches.length; i++)
  {
    switches[i].display();
  }
  fill(0.5);
  textAlign(RIGHT);
  textSize(12);
  text("SHIFT + Mouse - Orbit", width-20, 100);

  text("RIGHT CLICK + Mouse - Zoom", width-20, 120);
  text("SPACE - Generate new surface", width-20, 140);

  textMode(SHAPE);
  textSize(22);
  text("Mesh Generator", width-20, 40);
  textSize(14);
  text("Daniel Szemerey, AAC '16", width-20, 60);
  textMode(MODEL);
}


void mousePressed()
{
  for (int i=0; i<switches.length; i++)
  {

    switches[i].OnClick();
  }
}


class Button
{
  boolean onOff;
  float buttonColour;
  float buttonSizeX, buttonSizeY;
  PVector buttonPosition= new PVector();
  String buttonName;

  Button(String name, float x, float y, float sizeX, float sizeY)
  {
    onOff=false;
    buttonColour=0.5;


    buttonPosition.x= x;
    buttonPosition.y= y;
    buttonSizeX= sizeX;

    buttonSizeY= sizeY;
    buttonName= name;
  }

  void display()
  {
    rectMode(CENTER);
    textAlign(CENTER);
    textSize(12);
    pushMatrix();
    {
      //
      if (onOff) fill(0.5);
      else noFill();
      rect(buttonPosition.x, buttonPosition.y, buttonSizeX, buttonSizeY, 5);

      if (onOff) fill (0.9);
      else fill(0.5);
      translate(buttonPosition.x, buttonPosition.y+5, 0);
      text(buttonName, 0, 0);
    }
    popMatrix();
  }
  void OnClick ()
  {
    if (mouseX<buttonPosition.x+buttonSizeX/2 &&
      mouseX>buttonPosition.x-buttonSizeX/2 &&
      mouseY<buttonPosition.y+buttonSizeY/2 &&
      mouseY>buttonPosition.y-buttonSizeY/2)
    {
      onOff=!onOff;

      if (this==switches[0]) switches[1].onOff=!switches[0].onOff;
      if (this==switches[1])  switches[0].onOff=!switches[1].onOff;
      if (this==switches[2]) switches[3].onOff=false;
      if (this==switches[3])  switches[2].onOff=false;


      if (this==switches[0] || this==switches[1])
      {
        for (int i=0; i<distObjects.length; i++)
        {
          for (int j=0; j<distObjects.length; j++)
          {
            distObjects[i][j]= new Pyramid();
          }
        }
      }
    }
  }
}






















/*
{
 void mousePressed()
 
 if (mouseX<(20+width/5+40)+width/10+10 &&
 mouseX>40+width/5+10 &&
 mouseY<(height/10+30)/label.length+20+35 &&
 mouseY>(height/10+30)/label.length+20-35)
 {
 myMesh=!myMesh;
 for (int i=0; i<distObjects.length; i++)
 {
 for (int j=0; j<distObjects.length; j++)
 {
 distObjects[i][j]= new Pyramid();
 }
 }
 }
 
 if (mouseX<(20+width/5+40)+width/10+10 &&
 mouseX>40+width/5+10 &&
 mouseY<((height/10+30)/label.length)*2+20+35 &&
 mouseY>((height/10+30)/label.length)*2+20-35)
 {
 topView=!topView;
 }
 
 if (mouseX<(20+width/5+40)+width/10+10 &&
 mouseX>40+width/5+10 &&
 mouseY<((height/10+30)/label.length)*3+20+20 &&
 mouseY>((height/10+30)/label.length)*3+20-20)
 {
 topView=!topView;
 sideView=false;
 }
 
 if (mouseX<(20+width/5+40)+width/10+10 &&
 mouseX>40+width/5+10 &&
 mouseY<((height/10+30)/label.length)*4+20+20 &&
 mouseY>((height/10+30)/label.length)*4+20-20)
 {
 sideView=!sideView;
 topView=false;
 }
 }
 */

/*
  for (int i=0; i<label.length; i++)
 {
 pushMatrix();
 {
 translate((20+width/5+40), ((height/5+10)/label.length)*i +20);
 
 if (myMesh) 
 {
 if (i==0) fill(0.7);
 else noFill();
 } else if (!myMesh) 
 {
 if (i==1) fill(0.7);
 else noFill();
 } 
 if (topView)
 {
 if (i==2) fill(0.7);
 else noFill();
 } else if (sideView)
 {
 if (i==3) fill(0.7);
 else noFill();
 }
 rect(0, 0, width/10, (height/10+30)/label.length, 5);
 
 if (myMesh)
 {
 if (i==0) fill(0.9);
 else fill(0.5);
 } else if (!myMesh)
 {
 if (i==1) fill(0.9);
 else fill(0.5);
 }
 if (topView)
 {
 if (i==2) fill(0.9);
 else fill(0.5);
 } else if (sideView)
 {
 if (i==3) fill(0.9);
 else fill(0.5);
 }
 text(label[i], width/20, (height/10+30)/label.length/2+5);
 }
 popMatrix();
 }
 */