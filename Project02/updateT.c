#include <mex.h>
#include <math.h>

double nY,nX,con,h;
int n,m,yLength;
double *xs,*ys;

int getIndex(int i, int j, int k) {
    return i+j*(int)(nY+0.05)+(k-1)*(int)(nY+0.05)*(int)(nX+0.05);
}

// NTA T nY, nX, con, h, n, m, yLength
void mexFunction(int numInputs , mxArray *output[],int
numOutputs , const mxArray *input[])   // define the main function  
{  
    // Define Variables
    double* NTA;
    double* T;
    int i;
    mxArray *fOut;
    double* outVals;
    mwSize dimNum;
    mwSize dims[3];
    int j,k;
    double r1,r2,normR;

    // Associate Inputs
    NTA = mxGetPr(input[0]);
    output[0] = mxDuplicateArray(input[1]);
    fOut = output[0];
    T = mxGetPr(fOut);
    xs = mxGetPr(input[9]);
    ys = mxGetPr(input[10]);
    nY = *mxGetPr(input[2]);
    nX = *mxGetPr(input[3]);
    con = *mxGetPr(input[4]);
    h = *mxGetPr(input[5]);
    n = *mxGetPr(input[6]);
    m = *mxGetPr(input[7]);
    yLength = *mxGetPr(input[8]);
    // Associate Outputs
    for(j=0;j<nY;j++) {
        for(k=0;k<nX;k++) {
            // printf("index: %d\n",getIndex(j,k,1));
            // printf("NTA[%d %d] = %f\n",j,k,NTA[getIndex(j,k,0)]);
            T[getIndex(j,k,m)] = -1;
            switch((int)(NTA[getIndex(j,k,1)]+0.05)) {
                case 0 :
                    T[getIndex(j,k,m)] = NAN;
                    break;
                case 1 :
//                 R = [xs(k)-0.05,ys(end-j+1)];
//                 R = R./norm(R,2);
//                 T(j,k,m) = ((3*r1+3*r2))/(2*h))^(-1)*(-1 + r1/(2*h)*(4*T[getIndex(j,k-1,n)] - T[getIndex(j,k-2,n)]) + r2/(2*h)*(-T[getIndex(j+2,k,n)]+4*T[getIndex(j+1,k,n)]));
                    r1 = (xs[k]-0.05);
                    r2 = ys[yLength-j-1];
                    normR = sqrt(r1*r1+r2*r2);
                    r1 = r1/normR;
                    r2 = r2/normR;
                    
                    T[getIndex(j,k,m)] = (-1 + r1/(2*h)*(4*T[getIndex(j,k-1,n)] - T[getIndex(j,k-2,n)]) + r2/(2*h)*(-T[getIndex(j+2,k,n)]+4*T[getIndex(j+1,k,n)]))/(((3*r1+3*r2))/(2*h));
                    if(isnan(T[getIndex(j,k,m)])) {
                        printf("norm=%f\n",normR);
                        printf("r1=%f\n",r1);
                        printf("r2=%f\n",r2);
                        printf("j=%d\n",j);
                        printf("k=%d\n",k);
                        printf("yLength=%d\n",yLength);
                        printf("y=%f\n",ys[yLength-j-1]);
                    }
                    
                
                    break;

                case 2 :
                    T[getIndex(j,k,m)] = 60;
                    break;

                case 3 :
                    T[getIndex(j,k,m)] = T[getIndex(j,k,n)] + con*(T[getIndex(j+1,k,n)] - 2*T[getIndex(j,k,n)] + T[getIndex(j-1,k,n)]) + 
                        con*(T[getIndex(j,k+1,n)] - 2*T[getIndex(j,k,n)] + T[getIndex(j,k-1,n)]);
                    break;

                case 4 :
                T[getIndex(j,k,m)] = T[getIndex(j,k,n)] + con*(T[getIndex(j+1,k,n)] - 2*T[getIndex(j,k,n)] + T[getIndex(j-1,k,n)]) + 
                     con*(2*T[getIndex(j,k+1,n)] - 2*T[getIndex(j,k,n)]);
                     if(isnan(T[getIndex(j,k,m)])) {
                        printf("Case: %f\n",NTA[getIndex(j,k,1)]);
                    }
                    break;

                case 5 :
                    T[getIndex(j,k,m)] = T[getIndex(j,k,n)]+con*(
                        2*T[getIndex(j-1,k,n)]-2*
                        T[getIndex(j,k,n)])+con*(
                            (T[getIndex(j,k+1,n)]-2*
                            T[getIndex(j,k,n)]+
                            T[getIndex(j,k-1,n)]));
                            if(isnan(T[getIndex(j,k,m)])) {
                        printf("Case: %f\n",NTA[getIndex(j,k,1)]);
                    }
                    break;

                case 6 :
                    T[getIndex(j,k,m)] = T[getIndex(j,k,n)]+con*(
                        2*(T[getIndex(j-1,k,n)])-
                        2*(T[getIndex(j,k,n)]))+con*(
                        2*(T[getIndex(j,k+1,n)])-
                        2*T[getIndex(j,k,n)]);
                        if(isnan(T[getIndex(j,k,m)])) {
                        printf("Case: %f\n",NTA[getIndex(j,k,1)]);
                    }
                    break;

                case 7 : 
                 r1 = xs[k]-0.05;
                    r2 = ys[yLength-j+1];
                    normR = sqrt(r1*r1+r2*r2);
                    r1 = r1/normR;
                    r2 = r2/normR;
                    T[getIndex(j,k,m)] = (-1+(r1/(2*h))*(4*
                        (T[(getIndex(j,k-1,n))]) -
                        (T[j,k-2,n]))+2*
                        r2/h*T[getIndex(j+1,k,n)])/
                        ((3*r1+4*r2)/(2*h));
                    if(isnan(T[getIndex(j,k,m)])) {
                        printf("Case: %f\n",NTA[getIndex(j,k,1)]);
                    }
                    break;

                case 8 :
                //T(j,k,m) = -2*h/3 + (4/3)*T(j,k-1,n) - (1/3)*T(j,k-2,n);
                    T[getIndex(j,k,m)] = -2*h/3+(4/3)*T[getIndex(j,k-1,n)]-(1/3)*T[getIndex(j,k-2,n)];
                    if(isnan(T[getIndex(j,k,m)])) {
                        printf("Case: %f\n",NTA[getIndex(j,k,1)]);
                    }
                    break;

                default :
                    T[getIndex(j,k,m)] = -1;
                    break;
            if(isnan(T[getIndex(j,k,m)])) {
                T[getIndex(j,k,m)] = T[getIndex(j,k,n)];
            }
            }
        }
    }
    // printf("NTA[0]=%f\n",NTA[0]);
    // output[0] = fOut;


}