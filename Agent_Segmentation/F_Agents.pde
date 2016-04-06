class Agent
{
  Agent()
  {
  }

  void findPoint()
  {
  }

  void calcSurfaceIntersection()
  {
  }


  void findNearby()
  {
  }

  void drawAgent(float du, float dv)
  {
    fill(0.5, 0, 0);
    stroke(1, 0, 0);

    boolean odd=false;

    for (float v = knots_v[D_v]; v <= knots_v[knots_v.length-D_v-1]; v += dv) {
      odd=!odd; // Every second row is selected

      for (float u = knots_u[D_u]; u <= knots_u[knots_u.length-D_u-1]; u += du) {

        if (odd) u+=du*1.5;   // Every second row should be shifted if hex.

        PVector [] pt_All= new PVector[6];

        {
          pt_All[0] = surfPos(u, v   );
          pt_All[1] = surfPos(u+du, v  );
          pt_All[2] = surfPos(u+du*0.5, v+dv);

          pt_All[3] = surfPos(u, v   );
          pt_All[4] = surfPos(u+du*0.5, v+dv  );
          pt_All[5] = surfPos(u-du*0.5, v+dv);
        }

        stroke(0.75);


        if (switches2[0].onOff)
        {
          beginShape();
          {
            for (int i=0; i<pt_All.length-3; i++)
            {
              if (pt_All[i]!=null)  vertex(pt_All[i].x, pt_All[i].y, pt_All[i].z);
            }
            vertex(pt_All[0].x, pt_All[0].y, pt_All[0].z);
          }
          endShape();
          beginShape();
          {
            for (int i=3; i<pt_All.length; i++)
            {
              if (pt_All[i]!=null)  vertex(pt_All[i].x, pt_All[i].y, pt_All[i].z);
            }
            vertex(pt_All[0].x, pt_All[0].y, pt_All[0].z);
          }
          endShape();
        }
      }
    }
  }
}