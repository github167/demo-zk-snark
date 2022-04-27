mkdir ~/js && cd ~/js
npm init -y
npm install snarkjs

cp ~/snarkjs/build/circuit.wasm .
cp ~/snarkjs/build/circuit_final.zkey .
cp ~/snarkjs/build/verification_key.json .

cat << EOF > index.js
const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const p1 = await snarkjs.groth16.fullProve({a: 2, b: 17}, "circuit.wasm", "circuit_final.zkey");

    const p2 = await snarkjs.groth16.fullProve({a: 1, b: 34}, "circuit.wasm", "circuit_final.zkey");

    //console.log("Proof: ");
    //console.log(JSON.stringify(proof, null, 1));

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

    publicSignals = ['34'];
	
	// valid proof
    res = await snarkjs.groth16.verify(vKey, publicSignals, p1.proof);
    console.log(res?"Verification OK":"Invalid proof");

	// invalid proof
    res = await snarkjs.groth16.verify(vKey, publicSignals, p2.proof);
    console.log(res?"Verification OK":"Invalid proof");
}

run().then(() => {
    process.exit(0);
});
EOF
node index.js
