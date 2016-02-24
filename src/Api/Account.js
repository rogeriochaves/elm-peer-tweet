import ed from 'ed25519-supercop';
import crypto from 'crypto';

const getLocalStorage = () =>
  (typeof window !== 'undefined' && window.localStorage) || global.localStorage;

export const getKeys = () => {
  if (!localStorage.publicKey || !localStorage.secretKey) {
    const keypair = ed.createKeyPair(ed.createSeed());

    getLocalStorage().publicKey = keypair.publicKey.toString('hex');
    getLocalStorage().secretKey = keypair.secretKey.toString('hex');
  }

  const { publicKey, secretKey } = getLocalStorage();

  return { publicKey, secretKey };
};

export const hash = () => {
  const k = Buffer(getKeys().publicKey, 'hex');

  return crypto.createHash('sha1').update(k).digest('hex');
};

export default { getKeys, hash };
