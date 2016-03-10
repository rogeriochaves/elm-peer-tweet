import { dht } from './Utils';
import { getKeys, hash as head } from './Account';
import ed from 'ed25519-supercop';

const hexBuffer = (value) =>
  Buffer(value, 'hex');

const optionsFor = (item) =>
  item === head() ? { k: hexBuffer(getKeys().publicKey), sign, seq: 1 } : {};

const sign = (buf) =>
  ed.sign(buf, hexBuffer(getKeys().publicKey), hexBuffer(getKeys().secretKey));

const encodeTimestamp = (time) => {
  const length = Math.ceil(Math.log(time) / Math.log(2) / 8);
  let buffer = new Buffer(length);
  buffer.writeUIntBE(time, 0, length);

  return buffer;
}

const encodeArray = (value) =>
  Buffer.concat(value.map(x => new Buffer(x)));

const encodeKey = (key, value) => {
  switch (key) {
    case 't': return new Buffer(value);
    case 'd': return encodeTimestamp(value);
    case 'l': return encodeArray(value);
    case 'f': return encodeArray(value);
    case 'next': return encodeArray(value);
    default: return value;
  }
};

const encodeKeys = (item) =>
  Object.keys(item)
    .filter(x => x !== 'hash')
    .reduce((accumulated, key) => (
      { ...accumulated, [key]: encodeKey(key, item[key]) }
    ), {});

export const encodeItem = (hash, item) =>
  ({ v: encodeKeys(item), ...optionsFor(hash) });

export const publish = (item, callback) => {
  console.log('Publishing', item);

  dht.put(encodeItem(item.hash, item), (err) => {
    callback(err, item.hash);
  });
};

export default { publish, encodeItem };
