const AWS = require('aws-sdk');
const Hoek = require('@hapi/hoek');
const MD5 = require('md5');
const Promise = require('bluebird');
const Wreck = require('@hapi/wreck');

const S3_BUCKET = 'hocr-data';

const S3 = new AWS.S3();

const JobID = 6141;
const TotalEvents = 69;

const eventIds = [];

for (let i = 0; i < TotalEvents; i += 1) {
    eventIds.push(i + 1);
}

const execute = async () => {
    const lastHashByEvent = {};
    while (true) {
        const now = Date.now();
        await Promise.map(eventIds, async (eventId) => {
            try {
                const { res, payload } = await Wreck.get(`https://www.regattacentral.com/servlet/DisplayRacesResults?Method=getResults&job_id=${JobID}&event_id=${eventId}&_=${now}`);
                const hash = MD5(payload);
                const key = `${JobID}/${eventId}/${hash}.json`;
                try {
                    if (lastHashByEvent[eventId] === hash) {
                        return;
                    } else {
                        console.log(`[${new Date().toISOString()}] new hash ${hash} for ${eventId}`);
                    }
                    await S3.headObject({
                        Bucket: S3_BUCKET,
                        Key: key,
                    }).promise();
                    lastHashByEvent[eventId] = hash;
                } catch (e) {
                    await S3.putObject({
                        Bucket: S3_BUCKET,
                        Key: key,
                        Body: payload,
                    }).promise();
                    lastHashByEvent[eventId] = hash;
                }
            } catch (e) {
                const status = Hoek.reach(e, 'output.statusCode');
                if (status !== 404) {
                    console.error(e);
                }
            }
        }, { concurrency: 10 });
        await Hoek.wait(1000 * 20);
    }
}

execute();
