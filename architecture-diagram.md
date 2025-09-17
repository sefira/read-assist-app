# ReadAssist TTS Application Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                   USER                                          │
│                              (Web Browser)                                     │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ HTTPS Request
                      │ (Text + Voice Selection)
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            FRONTEND LAYER                                      │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                        Amazon S3                                        │  │
│  │                   (Static Website Hosting)                              │  │
│  │                                                                         │  │
│  │  • index.html (ReadAssist UI)                                          │  │
│  │  • Security Features:                                                  │  │
│  │    - Content Security Policy (CSP)                                     │  │
│  │    - XSS Prevention                                                    │  │
│  │    - Input Sanitization                                               │  │
│  │    - Rate Limiting (2s)                                               │  │
│  │    - Character Limit (3000)                                           │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ API Call (POST /tts)
                      │ JSON: {text, voiceId}
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              API LAYER                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                    Amazon API Gateway                                   │  │
│  │                        (REST API)                                      │  │
│  │                                                                         │  │
│  │  • Endpoint: /prod/tts                                                 │  │
│  │  • CORS Enabled                                                        │  │
│  │  • Request Validation                                                  │  │
│  │  • Throttling & Rate Limiting                                          │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ Lambda Invocation
                      │ Event: {body, headers}
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           COMPUTE LAYER                                        │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                       AWS Lambda                                        │  │
│  │                    (tts-function)                                       │  │
│  │                                                                         │  │
│  │  • Runtime: Node.js 20.x                                               │  │
│  │  • AWS SDK v3                                                          │  │
│  │  • Function: index.js                                                  │  │
│  │  • Memory: 128MB                                                       │  │
│  │  • Timeout: 30s                                                        │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ TTS Request
                      │ {Text, VoiceId, OutputFormat}
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            AI/ML LAYER                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                       Amazon Polly                                      │  │
│  │                  (Text-to-Speech Service)                               │  │
│  │                                                                         │  │
│  │  • Voices: Joanna, Matthew, Amy, Brian                                 │  │
│  │  • Output: MP3 Audio Stream                                            │  │
│  │  • Neural TTS Engine                                                   │  │
│  │  • Multi-language Support                                              │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ Audio Stream
                      │ (MP3 Binary Data)
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           STORAGE LAYER                                        │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                        Amazon S3                                        │  │
│  │                    (Audio File Storage)                                 │  │
│  │                                                                         │  │
│  │  • Bucket: tts-audio-files-*                                           │  │
│  │  • File Format: MP3                                                    │  │
│  │  • Public Read Access                                                  │  │
│  │  • Lifecycle Policies                                                  │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────────────┘
                      │
                      │ Pre-signed URL
                      │ (Temporary Access Link)
                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          RESPONSE FLOW                                         │
│                                                                                 │
│  Lambda → API Gateway → S3 Website → User Browser                              │
│                                                                                 │
│  Response: {audioUrl: "https://s3.../audio.mp3"}                               │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                           DEPLOYMENT LAYER                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                      GitHub Actions                                     │  │
│  │                        (CI/CD)                                          │  │
│  │                                                                         │  │
│  │  • Trigger: Push to main branch                                        │  │
│  │  • Deploy CloudFormation stack                                         │  │
│  │  • Update Lambda function                                              │  │
│  │  • Deploy website to S3                                                │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                    AWS CloudFormation                                  │  │
│  │                  (Infrastructure as Code)                              │  │
│  │                                                                         │  │
│  │  • Template: simple-template.yaml                                      │  │
│  │  • Stack: tts-app                                                      │  │
│  │  • Resources: S3, Lambda, API Gateway, IAM                             │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                            SECURITY LAYER                                      │
│                                                                                 │
│  • Content Security Policy (CSP) Headers                                       │
│  • XSS Prevention with Safe DOM Manipulation                                   │
│  • Input Sanitization and Validation                                           │
│  • Rate Limiting (2 seconds between requests)                                  │
│  • Character Limit Enforcement (3000 chars)                                    │
│  • Pre-signed URLs for Secure S3 Access                                       │
│  • IAM Least Privilege Permissions                                             │
└─────────────────────────────────────────────────────────────────────────────────┘
``` XSS Prevention with Safe DOM Manipulation                                   │
│  • Input Sanitization (HTML tag removal)                                       │
│  • Rate Limiting (2 seconds between requests)                                  │
│  • Character Limit Enforcement (3000 characters)                               │
│  • CORS Configuration                                                           │
│  • IAM Roles with Least Privilege                                              │
│  • HTTPS Encryption                                                             │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow

1. **User Input**: User enters text and selects voice in web browser
2. **Frontend Validation**: Client-side validation, sanitization, and rate limiting
3. **API Request**: HTTPS POST to API Gateway with JSON payload
4. **Lambda Processing**: Function processes request and calls Polly
5. **TTS Generation**: Polly converts text to speech (MP3)
6. **Storage**: Audio file stored in S3 bucket
7. **Response**: Pre-signed URL returned to client
8. **Playback**: Browser plays audio and offers download option

## Key Components

- **Frontend**: Secure React-like SPA with modern UI
- **API**: RESTful API with proper error handling
- **Compute**: Serverless Lambda with AWS SDK v3
- **AI/ML**: Amazon Polly neural TTS engine
- **Storage**: S3 for both website and audio files
- **Security**: Multi-layer security implementation
- **Deployment**: Automated CI/CD with GitHub Actions