const admin = require("firebase-admin");

// Tell Admin SDK to use the local emulator
process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";

admin.initializeApp({
  projectId: "psyched-timer-470611-r2",
});

const db = admin.firestore();

async function seed() {
  const artisanId = "K1QV3JljnceYOcj2fFE2ZST01473";
  const productId = "6J3NHVmEiZc0xxozKUeW";

  // Artisan doc
  await db
    .collection("artisans")
    .doc(artisanId)
    .set({
      displayName: "eggsy",
      bio: "im just a girl",
      address: {
        city: "Hyderabad",
        state: "Telangana",
        country: "India",
        addressLine1: "Miyapur",
        addressLine2: "Road no. 69",
      },
      profilePhotoUrl:
        "https://firebasestorage.googleapis.com/v0/b/artisan-app-media/o/artisans%2FK1QV3JljnceYOcj2fFE2ZST01473%2Fprofile.jpg?alt=media&token=a30521aa-8ad4-4980-a224-1856c89e05f5",
    });

  // Product doc
  await db
    .collection("products")
    .doc(productId)
    .set({
      artisanId,
      title: "paper mache balls",
      description: "balls made of paper",
      category: "handicraft",
      priceINR: 100,
      photos: [
        "https://firebasestorage.googleapis.com/v0/b/artisan-app-media/o/artisans%2FK1QV3JljnceYOcj2fFE2ZST01473%2Fproducts%2F6J3NHVmEiZc0xxozKUeW%2Fphoto_0.jpg?alt=media&token=5bf7eb43-fbe0-4104-8f04-078209eec734",
      ],
    });

  console.log("Seeding done ✅");
  process.exit(0);
}

seed();
