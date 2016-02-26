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
  Object.keys(item).reduce((accumulated, key) => {
    return { ...accumulated, [key]: encodeKey(key, item[key]) };
  }, { ...item });

const encodeItem = (hash, item) =>
  ({ v: encodeKeys(item), ...optionsFor(hash) });

export const publish = (data, callback, current = head()) => {
  const item = data[current];

  dht.put(encodeItem(current, item), (err) => {
    callback(err, current);
    if (item.next) publish(data, callback, item.next[0]);
  });
};

export default { publish };
