import { dht } from './Utils';
import { hash as head } from './Account';
import ed from 'ed25519-supercop';
import { getLocalStorage } from './Utils';

const hexBuffer = (value) =>
  Buffer(value, 'hex');

const optionsFor = (hash, item) =>
  hash === head() ? { k: hexBuffer(getLocalStorage().publicKey), sign, seq: item.d } : {};

const sign = (buf) =>
  ed.sign(buf, hexBuffer(getLocalStorage().publicKey), hexBuffer(getLocalStorage().secretKey));

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
    case 'n': return new Buffer(value);
    case 'a': return new Buffer(value);
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
  ({ v: encodeKeys(item), ...optionsFor(hash, item) });

export const publish = (item, callback) => {
  console.warn('Publishing', item);

  dht.put(encodeItem(item.hash, item), (err, hash) => {
    if (hash) console.info('Published', item, hash.toString('hex'));

    callback(err, item.hash);
  });
};

export default { publish, encodeItem };
