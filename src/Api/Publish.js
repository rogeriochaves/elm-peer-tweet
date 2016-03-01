import { dht } from './Utils';
import { getKeys, hash as head } from './Account';
import ed from 'ed25519-supercop';

const optionsFor = (item) =>
  item === head() ? {opts: { k: getKeys().publicKey, sign }} : {};

const sign = (buf) =>
  ed.sign(buf, getKeys().publicKey, getKeys().secretKey);

const encodeKey = (key, value) => {
  switch (key) {
    case 't': return new Buffer(value);
    case 'next': return Buffer.concat(value.map(x => new Buffer(x)));
    default: return value;
  }
};

const encodeKeys = (item) =>
  Object.keys(item)
    .filter(x => x !== 'hash')
    .reduce((accumulated, key) => (
      { ...accumulated, [key]: encodeKey(key, item[key]) }
    ), {});

const encodeItem = (hash, item) =>
  ({ v: encodeKeys(item), ...optionsFor(hash) });

export const publish = (item, callback) => {
  console.log(`Publishing`, item);

  dht.put(encodeItem(item.hash, item), (err) => {
    callback(err, item.hash);
  });
};

export default { publish };
