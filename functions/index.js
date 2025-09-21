require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const textToSpeech = require("@google-cloud/text-to-speech");
const fetch = require("node-fetch");

admin.initializeApp();
const db = admin.firestore();
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const ttsClient = new textToSpeech.TextToSpeechClient();

exports.generateTranscript = functions.https.onRequest(async (req, res) => {
  try {
    const { productId, includeTTS = true } = req.body;
    if (!productId) return res.status(400).send("Product ID is required");

    const productDoc = await db.collection("products").doc(productId).get();
    if (!productDoc.exists) return res.status(404).send("Product not found");
    const product = productDoc.data();

    const artisanDoc = await db
      .collection("artisans")
      .doc(product.artisanId)
      .get();
    if (!artisanDoc.exists) return res.status(404).send("Artisan not found");
    const artisan = artisanDoc.data();

    const imageParts = [];
    if (product.photos && Array.isArray(product.photos)) {
      for (const url of product.photos) {
        try {
          const response = await fetch(url);
          const buffer = await response.arrayBuffer();
          const base64Data = Buffer.from(buffer).toString("base64");
          imageParts.push({
            inlineData: { data: base64Data, mimeType: "image/jpeg" },
          });
        } catch (err) {
          console.warn("Failed to fetch image:", url, err.message);
        }
      }
    }

    const promptText = `
You are a storyteller AI. Generate a captivating 15-second reel transcript for an Indian artisan marketplace app.

Artisan:
- Name: ${artisan.displayName}
- Bio: ${artisan.bio}
- City: ${artisan.address?.city}, ${artisan.address?.state}, ${artisan.address?.country}

Product:
- Title: ${product.title}
- Category: ${product.category}
- Description: ${product.description}
- Price: ₹${product.priceINR}

Requirements:
1. Create an engaging 15-second story (approx 40-50 words)
2. Highlight cultural/historical significance
3. Showcase artisan skill and heritage
4. Make it emotionally compelling
5. Keep it authentic to Indian culture
6. Storytelling that connects tradition with modern consumers

Format: Return only the transcript text.
    `;

    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
    const result = await model.generateContent([
      { text: promptText },
      ...imageParts,
    ]);
    const transcript = result.response.text();

    let audioUrl = null;

    if (includeTTS) {
      try {
        const ttsRequest = {
          input: { text: transcript },
          voice: {
            languageCode: "en-IN",
            name: "en-IN-Wavenet-A",
            ssmlGender: "FEMALE",
          },
          audioConfig: { audioEncoding: "MP3", speakingRate: 0.9 },
        };

        const [ttsResponse] = await ttsClient.synthesizeSpeech(ttsRequest);

        const bucket = admin.storage().bucket();
        const fileName = `transcripts/audio/${productId}_${Date.now()}.mp3`;
        const file = bucket.file(fileName);

        await file.save(ttsResponse.audioContent, {
          metadata: { contentType: "audio/mpeg" },
        });
        await file.makePublic();
        audioUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
        console.log("TTS audio uploaded:", audioUrl);
      } catch (ttsError) {
        console.warn(
          "TTS generation/upload failed, continuing without audio:",
          ttsError.message
        );
      }
    }

    const updateData = {
      generatedTranscript: transcript,
      transcriptGeneratedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (audioUrl) updateData.audioUrl = audioUrl;

    await db.collection("products").doc(productId).update(updateData);

    res.send({
      success: true,
      transcript,
      productTitle: product.title,
      artisanName: artisan.displayName,
      audioUrl,
    });
  } catch (error) {
    console.error("Unexpected error in generateTranscript:", error);
    res.status(500).send("Unexpected server error. Check logs for details.");
  }
});
