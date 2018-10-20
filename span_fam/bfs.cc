#include "mex.h"
#include "queue"
#include "string"

#define DEBUG
#undef DEBUG

void
mexFunction (int nlhs, mxArray *plhs[],
	     int nrhs, const mxArray *prhs[])
{
  // Declarations //
  mwIndex root;
  mwIndex u, v, i;
  const mxArray *X = prhs[0];
  std::queue<mwIndex> q;
  mwIndex *adj, *ir, *jc;
  mwIndex deg;
  mxArray *tx;
  mwSize d;
  double *Xr, *Xi, *txr, *txi, *r;
  int nnz;

  nnz = mxGetNzmax(X);
  d = mxGetM(X);
  r = mxGetPr(prhs[1]);		// This should be the root node
  root = (int) *r - 1;
  
  mxAssert(root >= 0 && root < d, "Root is wrong!");
  mxAssert(mxIsSparse(X), "X must be sparse!\n");
  if (d != mxGetN(X))
    mexErrMsgTxt("X must be square!");
  
  ir = mxGetIr(prhs[0]);	// These fields describe the sparse matrix
  jc = mxGetJc(prhs[0]);
  Xr = mxGetPr(prhs[0]);
  Xi = mxGetPi(prhs[0]);

  #ifdef DEBUG
  mexPrintf("Begin breadth first search.\n");
  for(i = 0; i < nnz; ++i) mexPrintf("%1.2f + %1.2fi\n", Xr[2*i], Xi[i]);
  mexPrintf("root = %d\n", root);
  mexPrintf("d = %d\n", d);
  #endif

  plhs[0] = mxCreateDoubleMatrix(d, 1, mxCOMPLEX);
  tx = plhs[0];
  txr = mxGetPr(tx);
  txi = mxGetPi(tx);
  txr[root] = 1.;

  q.push(root);
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

  return;
}
