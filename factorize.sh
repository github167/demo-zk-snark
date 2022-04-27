mkdir ~/js && cd ~/js
npm init -y
npm install snarkjs

# copy the necessary resources
cp ~/snarkjs/build/circuit.wasm .
cp ~/snarkjs/build/circuit_final.zkey .
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json


# js to prove
cat << "EOF" > index.js
const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const p1 = await snarkjs.groth16.fullProve({a: 2, b: 17}, "circuit.wasm", "circuit_final.zkey");

    const p2 = await snarkjs.groth16.fullProve({a: 3, b: 19}, "circuit.wasm", "circuit_final.zkey");

    const p3 = await snarkjs.groth16.fullProve({a: 1, b: 34}, "circuit.wasm", "circuit_final.zkey");

    //console.log("Proof: ");
    //console.log(JSON.stringify(proof, null, 1));

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

    publicSignals = ['34'];
	
	// valid proof 2x17
    res = await snarkjs.groth16.verify(vKey, publicSignals, p1.proof);
    console.log("Factorization: 2x17==34: ", res);

	// invalid proof 3x19
    res = await snarkjs.groth16.verify(vKey, publicSignals, p2.proof);
    console.log("Factorization: 3x19==34: ", res);

	// invalid proof 1x34
    res = await snarkjs.groth16.verify(vKey, publicSignals, p3.proof);
    console.log("Factorization: 1x34==34: ", res);
}

run().then(() => {
    process.exit(0);
});
EOF

node index.js

# web page to prove
cp node_modules/snarkjs/build/snarkjs.min.js .

cat << EOF > index.html
<!doctype html>
<html>
<head>
  <title>Snarkjs client example</title>
</head>
<body>

  <h1>Snarkjs client example</h1>
  <button id="bGenProof1"> Create proof(33) </button>
  <button id="bGenProof2"> Create proof(37) </button>
  <button id="bGenProof3"> Create proof(1x33) </button>

  <!-- JS-generated output will be added here. -->
  <pre class="proof"> Proof: <code id="proof"></code></pre>

  <pre class="proof"> Result: <code id="result"></code></pre>


  <script src="snarkjs.min.js">   </script>
  
   <!-- This is the bundle generated by rollup.js -->
  <script>

const proofCompnent = document.getElementById('proof');
const resultComponent = document.getElementById('result');
const bGenProof = document.getElementById("bGenProof");

bGenProof1.addEventListener("click", prove33);
bGenProof2.addEventListener("click", prove37);
bGenProof3.addEventListener("click", proveSecond33);

function prove33() {calculateProof(3, 11, 33);}
function prove37() {calculateProof(3, 11, 37);}
function proveSecond33() {calculateProof(1, 33, 33);}

async function calculateProof(w1, w2, numToFactorize) {
    proofCompnent.innerHTML = "Processing...";
    resultComponent.innerHTML = "";
    const p1 = await snarkjs.groth16.fullProve( { a: w1, b: w2}, "circuit.wasm", "circuit_final.zkey");

    //proofCompnent.innerHTML = JSON.stringify(p1.proof, null, 1);
    //proofCompnent.innerHTML = JSON.stringify(p1.publicSignals, null, 1);
    console.log("w1:%d, w2:%d, numToFactorize:%d", w1, w2, numToFactorize);
    
    publicSignals = [numToFactorize];
    proofCompnent.innerHTML = "witness: a:"+w1+", b:"+w2+ " public input:" + numToFactorize;
    
    //proofCompnent.innerHTML = JSON.stringify(publicSignals, null, 1);    
    
    const vkey = await fetch("verification_key.json").then( function(res) {
        return res.json();
    });

    const res = await snarkjs.groth16.verify(vkey, publicSignals, p1.proof);

    resultComponent.innerHTML = res;
}

  </script>
</body>
</html>  
EOF

#cd ~/js
#npx http-server

