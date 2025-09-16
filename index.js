const { PollyClient, SynthesizeSpeechCommand } = require('@aws-sdk/client-polly');
const { S3Client, PutObjectCommand, GetObjectCommand } = require('@aws-sdk/client-s3');
const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
const crypto = require('crypto');

const polly = new PollyClient({});
const s3 = new S3Client({});

exports.handler = async (event) => {
    const headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };

    if (event.httpMethod === 'OPTIONS') {
        return { statusCode: 200, headers, body: '' };
    }

    try {
        const { text, voiceId = 'Joanna' } = JSON.parse(event.body);
        
        if (!text) {
            return {
                statusCode: 400,
                headers,
                body: JSON.stringify({ error: 'Text is required' })
            };
        }

        const pollyCommand = new SynthesizeSpeechCommand({
            Text: text,
            OutputFormat: 'mp3',
            VoiceId: voiceId
        });
        const pollyResult = await polly.send(pollyCommand);
        
        const fileName = `audio-${Date.now()}.mp3`;
        
        // Convert stream to buffer
        const chunks = [];
        for await (const chunk of pollyResult.AudioStream) {
            chunks.push(chunk);
        }
        const audioBuffer = Buffer.concat(chunks);
        
        const putCommand = new PutObjectCommand({
            Bucket: process.env.S3_BUCKET_NAME,
            Key: fileName,
            Body: audioBuffer,
            ContentType: 'audio/mpeg'
        });
        await s3.send(putCommand);

        const getCommand = new GetObjectCommand({
            Bucket: process.env.S3_BUCKET_NAME,
            Key: fileName
        });
        const audioUrl = await getSignedUrl(s3, getCommand, { expiresIn: 3600 });

        return {
            statusCode: 200,
            headers,
            body: JSON.stringify({ audioUrl })
        };

    } catch (error) {
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ error: error.message })
        };
    }
};