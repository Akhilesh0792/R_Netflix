import os
import time
import json
import boto3
from kafka import KafkaProducer

# Environment variables
BUCKET_NAME = os.environ.get('S3_BUCKET_NAME', 'akhilesh07')
KAFKA_BROKER = os.environ.get('KAFKA_BROKER', '192.168.20.130:9092')
AWS_REGION = os.environ.get('AWS_REGION', 'ap-south-1')

s3 = boto3.client('s3', region_name=AWS_REGION)

# Wait and initialize Kafka producer
producer = None
while not producer:
    try:
        producer = KafkaProducer(
            bootstrap_servers=[KAFKA_BROKER],
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )
        print(f"Connected to Kafka at {KAFKA_BROKER}")
    except Exception as e:
        print(f"Waiting for Kafka broker... {e}")
        time.sleep(3)

seen_keys = set()

def poll_s3():
    global seen_keys
    try:
        response = s3.list_objects_v2(Bucket=BUCKET_NAME)
        if 'Contents' in response:
            for item in response['Contents']:
                key = item['Key']
                # Ignore folder paths and check for valid video files
                if not key.endswith('/') and key.lower().endswith(('.mp4', '.mkv', '.webm')):
                    if key not in seen_keys:
                        # Construct actual direct URL for the uploaded video
                        video_url = f"https://{BUCKET_NAME}.s3.{AWS_REGION}.amazonaws.com/{key}"
                        
                        message = {
                            "event": "video_upload",
                            "bucket": BUCKET_NAME,
                            "key": key,
                            "title": key.split('/')[-1],
                            "url": video_url
                        }
                        
                        print(f"Publishing new video to Kafka: {key} -> {video_url}")
                        producer.send('video-upload-topic', message)
                        seen_keys.add(key)
            producer.flush()
    except Exception as e:
        print(f"Error polling S3: {e}")

if __name__ == '__main__':
    print(f"Starting S3 watcher on bucket: {BUCKET_NAME}")
    while True:
        poll_s3()
        time.sleep(5)