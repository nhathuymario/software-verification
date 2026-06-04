const aws = require('aws-sdk');
const mysql = require('mysql2/promise');
const s3 = new aws.S3();
const cloudwatch = new aws.CloudWatch();
exports.handler = async (event, context) => {
  console.log('Lambda started');
  try {
    if (!event.Records || !event.Records[0]) {
      return { statusCode: 400, body: JSON.stringify({ error: 'No S3 records' }) };
    }
    const record = event.Records[0];
    const bucket = record.s3.bucket.name;
    const key = decodeURIComponent(record.s3.object.key);
    console.log(Processing: s3:///);
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: 'ltjava_db'
    });
    const [rows] = await connection.execute('SELECT id FROM processing_jobs WHERE s3_key = ?', [key]);
    let jobId = rows.length > 0 ? rows[0].id : null;
    if (!jobId) {
      const [result] = await connection.execute(
        INSERT INTO processing_jobs (s3_key, file_name, status, lambda_request_id, progress, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, NOW(), NOW()),
        [key, key.split('/').pop(), 'PENDING', context.requestId, 0]
      );
      jobId = result.insertId;
    }
    await connection.execute(
      UPDATE processing_jobs SET status = ?, progress = ?, error_message = ?, updated_at = NOW() WHERE id = ?,
      ['PROCESSING', 50, 'Processing', jobId]
    );
    const params = { Bucket: bucket, Key: key };
    const data = await s3.getObject(params).promise();
    const fileBuffer = data.Body;
    const ext = key.split('.').pop().toLowerCase();
    const processResult = { fileType: ext.toUpperCase(), size: fileBuffer.length };
    const resultJson = JSON.stringify(processResult);
    const processingTime = 1000;
    await connection.execute(
      UPDATE processing_jobs SET status = ?, result_data = ?, processing_time_ms = ?, completed_at = NOW(), progress = 100, updated_at = NOW() WHERE id = ?,
      ['COMPLETED', resultJson, processingTime, jobId]
    );
    await connection.end();
    return { statusCode: 200, body: JSON.stringify({ message: 'Success', jobId: jobId }) };
  } catch (error) {
    console.error('Error:', error);
    return { statusCode: 500, body: JSON.stringify({ error: error.message }) };
  }
};
