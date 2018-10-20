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
  mwIndex root;
  const mxArray *X = prhs[0];
  mwIndex *adj, *ir, *jc;
  mwIndex deg;
  mxArray *tx;
  mwSize d;
  double *Xr, *Xi, *txr, *txi, *r;
  int nnz, u, v, i, bl, vert_ind;
  std::default_random_engine gen;

  nnz = mxGetNzmax(X);
  d = mxGetM(X);

  bool *intree = new bool[d];
  int *next = new int[d];
  int *br = new int[d];
  std::uniform_int_distribution<int> dist[d];
  for(i = 0; i < d; ++i) {
    dist[i] = std::uniform_int_distribution<int>(0, i);
    intree[i] = false;
    br[i] = 0;
    next[i] = -1;
  }

  root = 1;
  mxAssert(mxIsSparse(X), "X must be sparse!\n");
  if (d != mxGetN(X))
    mexErrMsgTxt("X must be square!");
  
  ir = mxGetIr(prhs[0]);	// These fields describe the sparse matrix
  jc = mxGetJc(prhs[0]);
  Xr = mxGetPr(prhs[0]);
  Xi = mxGetPi(prhs[0]);

  #ifdef DEBUG
  mexPrintf("Begin 'make a random tree'.\n");
  for(i = 0; i < nnz; ++i) mexPrintf("%1.2f + %1.2fi\n", Xr[2*i], Xi[i]);
  mexPrintf("root = %d\n", root);
  mexPrintf("d = %d\n", d);
  #endif

  plhs[0] = mxCreateDoubleMatrix(d, 1, mxCOMPLEX);
  tx = plhs[0];
  txr = mxGetPr(tx);
  txi = mxGetPi(tx);
  txr[root] = 1.;
  intree[root] = true;

  for(i = 0; i < d; ++i) {
    u = i;
    adj = ir + jc[u];
    deg = jc[u+1] - jc[u];
    while (!intree[u]) {
      vert_ind = dist[deg](gen);
      next[u] = adj[vert_ind];
      u = next[u];
    }
    u = i;
    bl = 0;
    while (!intree[u]) {
      intree[u] = 1;
      br[bl] = u;
      ++bl;
      u = next[u];
    }
    br[bl+1] = next[u];
    for(j = bl + 1; j > 1; --j) {
      txr[br[j-1]] = Xr[2*(jc[u] + i)] * txr[u] - Xi[jc[u] + i] * txi[u];
    }
  }    

  /*
while(!q.empty()) {
    u = q.front();
    q.pop();
    adj = ir + jc[u];
    deg = jc[u+1] - jc[u];

    #ifdef DEBUG
    mexPrintf("Vertex %d, Loop %d\n", u, loop);
    #endif    
    for(i = 0; i < deg; ++i) {
      v = adj[i];

      #ifdef DEBUG
      mexPrintf("\t%d\tValue: %2.3f+%2.3f i\n", v, txr[v], txi[v]);
      #endif
      if(txr[v] == 0 && txi[v] == 0){
	txr[v] = Xr[2*(jc[u] + i)] * txr[u] - Xi[jc[u] + i] * txi[u];
	txi[v] = Xr[2*(jc[u] + i)] * txi[u] + Xi[jc[u] + i] * txr[u];
     	q.push(v);

	#ifdef DEBUG
	mexPrintf("Edge from %d to %d:  %1.2f+%1.2fi\n", u+1, v+1, \
		  Xr[2*(jc[u] + i)], Xi[jc[u] + i]);
	mexPrintf("%1.2f+%1.2fi\t%1.2f+%1.2fi\n", \
		  txr[u], txi[u], txr[v], txi[v]);
	#endif
      }
    }
  }
 */
  
  delete intree;
  delete next;
  delete br;
  return;
}
