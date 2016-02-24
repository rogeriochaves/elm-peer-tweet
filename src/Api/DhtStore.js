import ed from 'ed25519-supercop';
import crypto from 'crypto';

const getLocalStorage = () =>
  (typeof window !== 'undefined' && window.localStorage) || global.localStorage;

const createKeysIfMissing = () => {
  if (!localStorage.publicKey || !localStorage.secretKey) {
    const keypair = ed.createKeyPair(ed.createSeed());

    getLocalStorage().publicKey = keypair.publicKey.toString('hex');
    getLocalStorage().secretKey = keypair.secretKey.toString('hex');
  }
}

export const initializeAccount = () => {
  createKeysIfMissing();
}

export const accountHash = () => {
  const k = Buffer(localStorage.publicKey, 'hex');

  return crypto.createHash('sha1').update(k).digest('hex');
}
