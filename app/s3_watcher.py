import os
import time
import json
import boto3
from kafka import KafkaProducer

AWS_REGION = os.getenv("AWS_DEFAULT_REGION", "ap-south-1")
BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
KAFKA_BROKER = os.getenv("KAFKA_BROKER", "localhost:9092")
TOPIC = "video-upload-topic"

s3 = boto3.client("s3", region_name=AWS_REGION)
producer = KafkaProducer(
    bootstrap_servers=[KAFKA_BROKER],
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

seen_objects = set()

def poll_s3():
    print(f"Monitoring S3 bucket: {BUCKET_NAME} for new videos...")
    while True:
        try:
            resp = s3.list_objects_v2(Bucket=BUCKET_NAME)
            if "Contents" in resp:
                for obj in resp["Contents"]:
                    key = obj["Key"]
                    if key.endswith(('.mp4', '.mkv', '.mov')) and key not in seen_objects:
                        seen_objects.add(key)
                        url = f"https://{BUCKET_NAME}.s3.{AWS_REGION}.amazonaws.com/{key}"
                        payload = {"title": key, "video_url": url, "timestamp": str(obj["LastModified"])}
                        producer.send(TOPIC, value=payload)
                        producer.flush()
                        print(f"Event published to Kafka: {payload}")
        except Exception as e:
            print("Error polling S3:", e)
        time.sleep(5)

if __name__ == "__main__":
    poll_s3()