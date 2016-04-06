float fader_u(float u, int k)
{
  return basisn(u, k, D_u, knots_u);
}
float fader_v(float u, int k)
{
  return basisn(u, k, D_v, knots_v);
}

float basisn(float u, int k, int d, float [] knots) { 
  if (d == 0) { 
    return basis0(u, k, knots);
  }
  else { 
    float b1 = basisn(u, k, d-1, knots) * (u - knots[k]) / (knots[k+d] -
      knots[k]);
    float b2 = basisn(u, k+1, d-1, knots) * (knots[k+d+1] - u) / (knots[k+d+1]
      - knots[k+1]);
    return b1 + b2;
  }
}
float basis0(float u, int k, float [] knots)
{ 
  if (u >= knots[k] && u < knots[k+1]) return 1;
  else return 0;
}