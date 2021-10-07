git clone https://github.com/kendricktan/hello-world-zk-dapp.git
cd hello-world-zk-dapp
npm install

cat << 'EOF' > packages/scripts/abc.js
const zkSnark = require("snarkjs");
const compiler = require("circom");
const fs = require('fs'); 


const {
  stringifyBigInts,
  unstringifyBigInts
} = require("snarkjs/src/stringifybigint");

const {
  genPrivateKey,
  genPublicKey,
  formatBabyJubJubPrivateKey,
  SNARK_FIELD_SIZE
} = require("./utils/crypto");

const validSk1 = zkSnark.bigInt(
  "5127263858703129043234609052997016034219110701251230596053007266606287227503"
);
const validSk2 = zkSnark.bigInt(
  "859505848622195548664064193769263253816895468776855574075525012843176328128"
);

const validPub1 = genPublicKey(validSk1);
const validPub2 = genPublicKey(validSk2);

async function main() {
		const sk = validSk1;
		const pks = [validPub1, validPub2];
        const circuitDef = await compiler(require.resolve("zk-circuits/src/circuit.circom"));
        const circuit = new zkSnark.Circuit(circuitDef);
		
		const zk = zkSnark.groth;
		console.log("Setup and generate vk, pk")
		const setup = zk.setup(circuit);
		fs.writeFileSync("pk", JSON.stringify(stringifyBigInts(setup.vk_proof)), "utf8");
		fs.writeFileSync("vk", JSON.stringify(stringifyBigInts(setup.vk_verifier)), "utf8");
		setup.toxic  // Must be discarded.
		
		
		console.log("Generate witness");
		const circuitInputs = {
			privateKey: formatBabyJubJubPrivateKey(sk),
			publicKeys: pks
		};	
		const witness = circuit.calculateWitness(stringifyBigInts(circuitInputs));
		//const publicSignals = witness.slice(1, circuit.nPubInputs + circuit.nOutputs + 1);
		
		
		console.log("Generate proof....");
		vk_proof =   JSON.parse(fs.readFileSync("./pk", "utf8"));
        const {proof, publicSignals} = zk.genProof(unstringifyBigInts(vk_proof), witness);
		//console.log(proof);
		//console.log(publicSignals);
		
		const vk_verifier = JSON.parse(fs.readFileSync("./vk", "utf8"));
		if (zk.isValid(unstringifyBigInts(vk_verifier), proof, publicSignals)) {
			console.log("The proof is valid");
		} else {
			console.log("The proof is not valid");
}


		
}
main();

EOF

