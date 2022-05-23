

* Alternate way to create buckets, use the aws cli.

```
AWS_ACCESS_KEY_ID=admin
AWS_SECRET_ACCESS_KEY=miniominio
AWS_DEFAULT_REGION=local
aws --endpoint-url=http://localhost:9000 s3api create-bucket --bucket order
aws --endpoint-url=http://localhost:9000 s3api create-bucket --bucket sku
```

* todo if a polic needs to be established

```
mc config host add minio http://minio:9000 admin miniominio --api s3v4
mc mb minio/public
mc policy set download minio/public
```

