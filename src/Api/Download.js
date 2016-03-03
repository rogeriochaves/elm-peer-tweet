import { dht } from './Utils';

const validKeys = ['t', 'next'];

const decodeKey = (key, value) => {
  switch (key) {
    case 't': return { [key]: value.toString() };
    case 'next': return { [key]: value.toString().match(/.{1,40}/g) };
    default: return {};
  }
};

const decodeKeys = (values) =>
  Object.keys(values)
    .reduce((accumulated, key) => (
      { ...accumulated, ...decodeKey(key, values[key]) }
    ), {});

const decodeItem = (hash, item) =>
  ({ hash: hash, ...decodeKeys(item.v) });

export const download = (hash, callback) => {
  console.log('Downloading', hash);

  dht.get(hash, (err, item) => {
    callback(err, item && decodeItem(hash, item));
  });
};

export default { download };
