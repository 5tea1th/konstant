require("dotenv").config();
const textToSpeech = require("@google-cloud/text-to-speech");
const fs = require("fs");

const ttsClient = new textToSpeech.TextToSpeechClient();

async function testTTS() {
  const [response] = await ttsClient.synthesizeSpeech({
    input: { text: "Hello from your artisan app!" },
    voice: { languageCode: "en-IN", ssmlGender: "FEMALE" },
    audioConfig: { audioEncoding: "MP3" },
  });
  fs.writeFileSync("test.mp3", response.audioContent, "binary");
  console.log("✅ TTS worked! Check test.mp3");
}

testTTS();
