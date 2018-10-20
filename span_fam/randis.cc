#include <mex.h>
#include <queue>
#include <string>
#include <random>
#include <functional>

#define DEBUG
#undef DEBUG

void
mexFunction (int nlhs, mxArray *plhs[],
	     int nrhs, const mxArray *prhs[])
{
  // Declarations //
  double *dd;
  int d;
  int Nt = 8, i, j;
  std::default_random_engine gen;

  dd = mxGetPr(prhs[0]);
  d = (int) *dd;

  std::uniform_int_distribution<int> dist[d] = {};
  for(i = 0; i < d; ++i) {
    dist[i] = std::uniform_int_distribution<int>(0, i);
  }

  // std::uniform_int_distribution<int> dist1(0,d);

  // for(i=0; i<Nt; ++i)mexPrintf("%d\n", dist1(gen));
  for(i = 0; i < d; ++i) {
    for(j = 0; j < Nt; ++j) {
      mexPrintf("%d\n", dist[i](gen));
    }
  }

  return;
}
