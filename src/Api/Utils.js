import ed from 'ed25519-supercop';
import DHT from 'bittorrent-dht';

export const getLocalStorage = () =>
  (typeof window !== 'undefined' && window.localStorage) || global.localStorage;

export const dht = new DHT({ verify: ed.verify });
