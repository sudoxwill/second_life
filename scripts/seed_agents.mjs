/**
 * Crée 3 comptes agent de test dans Firebase Auth + leurs documents Firestore.
 * Usage : node scripts/seed_agents.mjs
 */

const API_KEY     = "AIzaSyAYoX-ZKulMhDythsfVtQzcwtweftLx0yw";
const PROJECT_ID  = "test-839c3";
const AUTH_SIGNUP = `https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${API_KEY}`;
const AUTH_SIGNIN = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${API_KEY}`;
const FIRESTORE   = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents`;

const AGENTS = [
  {
    email: "agent.kofi@secondlife.test",
    password: "Agent1234!",
    displayName: "Kofi Mensah",
    relayPointId: "RP001",
    relayPointName: "EcoCentre de Bè",
    serviceHours: "Lun-Sam 7h-18h",
    relayPointDescription: "Principal point relais du quartier Bè — plastique, métal, verre",
  },
  {
    email: "agent.ama@secondlife.test",
    password: "Agent1234!",
    displayName: "Ama Kodjovi",
    relayPointId: "RP002",
    relayPointName: "Point Relais Tokoin",
    serviceHours: "Lun-Ven 8h-17h",
    relayPointDescription: "Spécialisé plastique et carton, quartier Tokoin",
  },
  {
    email: "agent.sena@secondlife.test",
    password: "Agent1234!",
    displayName: "Sèna Adjamagbo",
    relayPointId: "RP003",
    relayPointName: "Centre Recyclage Lacs",
    serviceHours: "Mar-Sam 9h-18h",
    relayPointDescription: "Tous types de déchets recyclables acceptés",
  },
];

async function signUpOrSignIn(agent) {
  // Essaie d'abord inscription, bascule sur connexion si le compte existe déjà.
  let res = await fetch(AUTH_SIGNUP, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email: agent.email, password: agent.password, returnSecureToken: true }),
  });
  let data = await res.json();

  if (data.error?.message === "EMAIL_EXISTS") {
    res = await fetch(AUTH_SIGNIN, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: agent.email, password: agent.password, returnSecureToken: true }),
    });
    data = await res.json();
  }

  if (data.error) throw new Error(`Auth error for ${agent.email}: ${data.error.message}`);
  return { uid: data.localId, idToken: data.idToken };
}

function toFirestoreDoc(agent) {
  return {
    fields: {
      displayName:           { stringValue: agent.displayName },
      relayPointId:          { stringValue: agent.relayPointId },
      relayPointName:        { stringValue: agent.relayPointName },
      serviceHours:          { stringValue: agent.serviceHours },
      relayPointDescription: { stringValue: agent.relayPointDescription },
      isActive:              { booleanValue: true },
    },
  };
}

async function writeFirestoreDoc(uid, idToken, agent) {
  const url = `${FIRESTORE}/relay_agents/${uid}`;
  const res = await fetch(url, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${idToken}`,
    },
    body: JSON.stringify(toFirestoreDoc(agent)),
  });
  const data = await res.json();
  if (data.error) throw new Error(`Firestore error: ${data.error.message} (status ${data.error.code})`);
  return data;
}

console.log("🌱  Seeding test agents in Firebase...\n");

for (const agent of AGENTS) {
  process.stdout.write(`  → ${agent.displayName} (${agent.email})… `);
  try {
    const { uid, idToken } = await signUpOrSignIn(agent);
    await writeFirestoreDoc(uid, idToken, agent);
    console.log(`✓  uid: ${uid}`);
  } catch (err) {
    console.log(`✗  ${err.message}`);
  }
}

console.log("\nDone. Les agents peuvent se connecter avec le mot de passe : Agent1234!");
