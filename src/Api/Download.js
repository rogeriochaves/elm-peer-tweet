import { dht } from './Utils';

const decodeKey = (key, value) => {
  switch (key) {
    case 't': return { [key]: value.toString() };
    case 'd': return { [key]: value.readIntBE(0, value.length) };
    case 'next': return { [key]: value.toString() ? value.toString().match(/.{1,40}/g) : [] };
    default: return {};
  }
};

const decodeKeys = (values) =>
  Object.keys(values)
    .reduce((accumulated, key) => (
      { ...accumulated, ...decodeKey(key, values[key]) }
    ), {});

const addNext = (values) =>
  ({...values, next: (values.next || new Buffer([])) });

const decodeItem = (hash, item) =>
  ({ hash: hash, ...decodeKeys(addNext(item.v)) });

export const download = (hash, callback) => {
  console.log('Downloading', hash);

  dht.get(hash, (err, item) => {
    callback(err, item && decodeItem(hash, item));
  });
};

export default { download };
