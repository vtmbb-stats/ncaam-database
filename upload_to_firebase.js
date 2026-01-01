const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin with service account
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function uploadStats() {
  try {
    const rawData = fs.readFileSync('./player_stats.json', 'utf8');
    const players = JSON.parse(rawData);
    
    console.log(`Uploading ${players.length} players to Firebase...`);
    
    let batch = db.batch();
    const timestamp = admin.firestore.FieldValue.serverTimestamp();
    
    let count = 0;
    for (const player of players) {
      const playerRef = db.collection('players_stats').doc(player.playerId);
      
      batch.set(playerRef, {
        ...player,
        lastUpdated: timestamp
      }, { merge: true });
      
      count++;
      
      // Firestore batch limit is 500 operations
      if (count % 500 === 0) {
        await batch.commit();
        console.log(`Uploaded ${count} players...`);
        batch = db.batch();
      }
    }
    
    // Commit any remaining operations
    if (count % 500 !== 0) {
      await batch.commit();
    }
    
    console.log(`✅ Successfully uploaded ${count} players!`);
    
    // Update metadata
    await db.collection('metadata').doc('lastUpdate').set({
      timestamp: timestamp,
      playerCount: count
    });
    
    console.log('✅ Metadata updated');
    
  } catch (error) {
    console.error('Error uploading to Firebase:', error);
    process.exit(1);
  }
}

uploadStats()
  .then(() => {
    console.log('Upload complete!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Upload failed:', error);
    process.exit(1);
  });