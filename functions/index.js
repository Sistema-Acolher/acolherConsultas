// Import Firebase Functions v2 and Firebase Admin SDK
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onRequest} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const moment = require("moment-timezone");

// Initialize Firebase Admin
initializeApp();

exports.testExpiredTasksHttp = onRequest(async (req, res) => {
  await checkExpiredTasks();// Call the logic of checkExpiredTasks
  res.send("Expired tasks checked!");
});

exports.checkExpiredTasks = onSchedule("every 24 hours", async (event) => {
  const db = getFirestore();
  // Set today's date to 00:00:00 in Brazil's timezone
  const today = moment.tz("America/Sao_Paulo").startOf("day").toDate();
  try {
    // Query the tasks collection for documents with a `date` before today
    const expiredTasksQuery = await db.collection("consultas")
        .where("dataHorario", "<", today)
        .where("estado", "=", "agendada").get();
    console.log(today);
    if (expiredTasksQuery.empty) {
      console.log("No expired tasks found.");
      return;
    }
    // Loop through expired documents
    expiredTasksQuery.forEach(async (doc) => {
      try {
        // Update the "estado" field to "atrasada"
        // await doc.ref.update({ estado: "atrasada" });
        await getFirestore()
            .collection("messages")
            .add({consulta: doc.id, data: doc.data().dataHorario.toDate()});
        console.log(`Consulta ${doc.id}: ${doc.data().dataHorario}`);
      } catch (error) {
        console.error(`Failed to update task ${doc.id}:`, error);
      }
    });
    console.log("Expired tasks check completed.");
  } catch (error) {
    console.error("Error checking for expired tasks:", error);
  }
});

/** Função teste */
async function checkExpiredTasks() {
  const db = getFirestore();
  // Set today's date to 00:00:00 in Brazil's timezone
  const today = moment.tz("America/Sao_Paulo").startOf("day").toDate();
  try {
    const expiredTasksQuery = await db
        .collection("consultas")
        .where("dataHorario", "<", today)
        .where("estado", "=", "agendada")
        .get();
    console.log(today);
    if (expiredTasksQuery.empty) {
      console.log("No expired tasks found.");
      return;
    }
    // Loop through expired documents
    expiredTasksQuery.forEach(async (doc) => {
      try {
        // Update the "estado" field to "atrasada"
        // await doc.ref.update({ estado: "atrasada" });
        await getFirestore()
            .collection("messages")
            .add({consulta: doc.id, data: doc.data().dataHorario.toDate()});
        console.log(`Consulta ${doc.id}: ${doc.data().dataHorario.toDate()}`);
      } catch (error) {
        console.error(`Failed to update task ${doc.id}:`, error);
      }
    });
    console.log("Expired tasks check completed.");
  } catch (error) {
    console.log("Error checking for expired tasks:", error);
  }
}
