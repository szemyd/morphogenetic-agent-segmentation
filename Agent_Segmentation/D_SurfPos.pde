PVector surfPos(float u, float v)
{
  PVector pt = new PVector();
  for (int i = 0; i <= N_u; i++) {
    for (int j = 0; j <= N_v; j++) {
      PVector pt_k = new PVector( ctrl_pts[i][j].x, ctrl_pts[i][j].y, ctrl_pts[i][j].z );
      pt_k.mult( fader_u(u, i) * fader_v(v, j) );
      pt.add( pt_k );
    }
  }
  return pt;
}