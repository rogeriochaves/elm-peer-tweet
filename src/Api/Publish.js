import { dht } from './Utils';
import { getKeys, hash as head } from './Account';
import ed from 'ed25519-supercop';
import JSONB from 'json-buffer';

const optionsFor = (item) =>
  item === head() ? {opts: { k: getKeys().publicKey, sign }} : {};

const sign = (buf) =>
  ed.sign(buf, getKeys().publicKey, getKeys().secretKey)

const getItem = (data, hash) =>
  ({ ...data[hash], ...optionsFor(hash) });

const encodeKey = (key, value) => {
  switch (key) {
    case 't': return new Buffer(value);
    case 'next': return Buffer.concat(value.map(x => new Buffer(x)));
    default: return value;
  }
}

const encodeItemV = (v) =>
  Object.keys(v).reduce((accumulated, key) => {
    return { ...accumulated, [key]: encodeKey(key, v[key]) };
  }, { ...v });

const encodeItem = (rawTweet) =>
  ({ ...rawTweet, v: encodeItemV(rawTweet.v) });

export const publish = (data, callback, current = head()) => {
  const item = getItem(data, current);

  dht.put(encodeItem(item), (err) => {
    if (err) callback(err);

    callback(current);
    if (item.v.next) publish(data, callback, item.v.next[0]);
  });
};

//
// const encodeTweet = (rawTweet) => JSONB.stringify({
//   v: {
//     t: new Buffer(rawTweet.v.t),
//     next: Buffer.concat(rawTweet.v.next.map(x => new Buffer(x)))
//   }
// })
//
// export const publish = (head, data) => (text, callback) => {
//   const tweet = buildTweet(head, data)(text);
//
//   dht.put(encodeTweet(tweet), (err) => {
//     callback(err, tweet);
//   });
// };

export default { publish };
