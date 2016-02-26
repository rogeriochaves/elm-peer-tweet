import { dht } from './Utils';
import { getKeys, hash as head } from './Account';
import ed from 'ed25519-supercop';

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
    callback(err, current);
    if (item.v.next) publish(data, callback, item.v.next[0]);
  });
};

export default { publish };
