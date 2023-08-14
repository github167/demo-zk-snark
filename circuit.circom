template Multiplier(n) { //PUBLIC INPUT ARG
    signal private input a; //PRIVATE INPUT
    signal private input b; //PRIVATE INPUT
    signal output c; //PUBLIC OUTPUT

    c <== a*b*n; //OUTPUT PROOF
}

component main = Multiplier(1000); //PUBLIC INPUT FROM MAIN FUNCTION CALL