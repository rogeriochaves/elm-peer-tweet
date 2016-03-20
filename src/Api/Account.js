import ed from 'ed25519-supercop';
import crypto from 'crypto';
import { getLocalStorage } from './Utils';

export const createKeys = () => {
  if (!localStorage.publicKey || !localStorage.secretKey) {
    const keypair = ed.createKeyPair(ed.createSeed());

    getLocalStorage().publicKey = keypair.publicKey.toString('hex');
    getLocalStorage().secretKey = keypair.secretKey.toString('hex');
  }

  const { publicKey, secretKey } = getLocalStorage();

  return { publicKey, secretKey };
};

export const hash = () => {
  const { publicKey, secretKey } = getLocalStorage();

  if (publicKey && secretKey) {
    const k = Buffer(publicKey, 'hex');

    return crypto.createHash('sha1').update(k).digest('hex');
  }

  return null;
};

export const createKeysWithHash = () => {
  let keys = createKeys();

  return { hash: hash(), keys: keys };
};

export const setKeys = ({ publicKey, secretKey }) => {
  getLocalStorage().publicKey = publicKey;
  getLocalStorage().secretKey = secretKey;

  return hash();
};

export const initialAccount = () => ({
  head: {
    hash: hash(),
    d: Date.now(),
    next: [],
    f: [],
    n: ""
  },
  tweets: [],
  followBlocks: []
});

export default { createKeys, hash, initialAccount, createKeysWithHash, setKeys };
