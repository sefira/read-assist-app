const AWS = require('aws-sdk');
const crypto = require('crypto');

const polly = new AWS.Polly();
const s3 = new AWS.S3();

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

        const pollyParams = {
            Text: text,
            OutputFormat: 'mp3',
            VoiceId: voiceId
        };
        
        const pollyResult = await polly.synthesizeSpeech(pollyParams).promise();
        const fileName = `audio-${crypto.randomUUID()}.mp3`;
        
        const s3Params = {
            Bucket: process.env.S3_BUCKET_NAME,
            Key: fileName,
            Body: pollyResult.AudioStream,
            ContentType: 'audio/mpeg'
        };
        
        await s3.upload(s3Params).promise();

        const audioUrl = s3.getSignedUrl('getObject', {
            Bucket: process.env.S3_BUCKET_NAME,
            Key: fileName,
            Expires: 3600
        });

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