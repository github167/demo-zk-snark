template X() {
    signal input i;
    signal input j;
    signal output out;

    var r = 0;
    for (var n=0; n<i; n++) {
        r++;
    }

    i === r;
    out <== r;
}

component main = X();
