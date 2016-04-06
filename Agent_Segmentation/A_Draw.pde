void drawSurf(float du, float dv)
{

  fill(0.5, 1, 1);
  noStroke();

  boolean odd=false;
  int l=0;
  int selector;

  if (switches[0].onOff==true)  selector=3;
  else  selector=1;



  for (float v = knots_v[D_v]; v <= knots_v[knots_v.length-D_v-1]; v += dv) {
    odd=!odd; // Every second row is selected
    l++;
    int m=0;

    for (float u = knots_u[D_u]; u <= knots_u[knots_u.length-D_u-1]; u += du*selector) {
      m++;
      float pastU=u; // Memorize current position.

      if (switches[0].onOff) 
      {
        if (odd) u+=du*1.5;   // Every second row should be shifted if hex.
      } 

      PVector [] pt_All= new PVector[6];
      float myCoor= sqrt(0.75); // Calculate the 'v' distance from the middle point.


      pt_All[0] = surfPos (u-du, v                 );
      pt_All[1] = surfPos (u-du*0.5, v+dv*myCoor   );
      pt_All[2] = surfPos (u+du*0.5, v+dv*myCoor   );
      pt_All[3] = surfPos (u+du, v                 );
      pt_All[4] = surfPos (u+du*0.5, v-dv*myCoor   );
      pt_All[5] = surfPos (u-du*0.5, v-dv*myCoor   );

      beginShape();
      {
        vertex(pt_All[0].x, pt_All[0].y, pt_All[0].z);
        vertex(pt_All[1].x, pt_All[1].y, pt_All[1].z);
        vertex(pt_All[2].x, pt_All[2].y, pt_All[2].z);
        vertex(pt_All[3].x, pt_All[3].y, pt_All[3].z);
        vertex(pt_All[4].x, pt_All[4].y, pt_All[4].z);
        vertex(pt_All[5].x, pt_All[5].y, pt_All[5].z);
        vertex(pt_All[0].x, pt_All[0].y, pt_All[0].z);
      }
      endShape();


      distObjects[l][m].position(pt_All);

      u=pastU; // Set the counter back to the orginal.
    }
  }
}

void drawNrml(float du, float dv)
{
  stroke(0, 1, 1);
  boolean odd=false;
  int l=0;
  int selector;

  if (switches[0].onOff==true)  selector=3;
  else  selector=1;

  for (float v = knots_v[D_v]; v <= knots_v[knots_v.length-D_v-1]; v += dv) {
    odd=!odd; // Every second row is selected
    l++;
    int m=0;
    for (float u = knots_u[D_u]; u <= knots_u[knots_u.length-D_u-1]; u += du*selector) {
      m++;
      float pastU=u; // Memorize current position.

      if (switches[0].onOff) 
      {
        if (odd) u+=du*1.5;   // Every second row should be shifted if hex.
      } 


      PVector vN_1 = surfPos(u, v );
      PVector vN_2 = surfPos(u+0.0001, v );
      PVector vN_3 = surfPos(u, v+0.0001 );

      PVector tan_U = PVector.sub(vN_1, vN_2);
      PVector tan_V = PVector.sub(vN_1, vN_3);

      PVector nrml  = tan_V.cross(tan_U);
      nrml.normalize();

      pushMatrix();
      translate(vN_1.x, vN_1.y, vN_1.z);
      line(0, 0, 0, nrml.x*10, nrml.y*10, nrml.z*10);
      popMatrix();

      distObjects[l][m].setNrml(nrml, vN_1);

      u=pastU;
    }
  }
}

void drawCtrlPts()
{
  fill(0.5, 1, 1);
  noStroke();
  for (int i = 0; i <= N_u; i++) {
    for (int j = 0; j <= N_v; j++) {
      pushMatrix();
      translate( ctrl_pts[i][j].x, ctrl_pts[i][j].y, ctrl_pts[i][j].z );
      sphere(5);
      popMatrix();
    }
  }
}

void drawAttractor()
{
  pushMatrix();
  {
    translate(att.x, att.y, att.z);
    fill(0, 0, 1, 0.5);
    sphere(30);
    fill(0, 0, 1, 1);
    sphere(15);
  }
  popMatrix();
  noFill();
}

void drawPyramids()
{
  for (int i=0; i<distObjects.length; i++) {
    for (int j=0; j<distObjects.length; j++) {
      distObjects[i][j].distance(); // Calculates the height of the pyramid.
      distObjects[i][j].display(); // Draws the pyramid
    }
  }
}