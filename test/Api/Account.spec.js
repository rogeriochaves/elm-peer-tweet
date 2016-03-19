import { expect } from 'chai';

import Account from '../../src/Api/Account';

describe('Account', () => {
  describe('createKeys', () => {
    it('creates key if it is not on localstorage', () => {
      global.localStorage = {};

      let { publicKey, secretKey } = Account.createKeys();

      expect(publicKey).to.be.a('string');
      expect(publicKey.length).to.equal(64);

      expect(secretKey).to.be.a('string');
      expect(secretKey.length).to.equal(128);
    });

    it('does not creates key if it is already there', () => {
      global.localStorage = { publicKey: 'foo', secretKey: 'bar' };

      let { publicKey, secretKey } = Account.createKeys();

      expect(publicKey).to.equal('foo');
      expect(secretKey).to.equal('bar');
    });
  });

  it('returns the right account hash', () => {
    global.localStorage = { publicKey: '6393a821af08e151399a8df339d02a9e36134b3da5f893849673cf176810eb98', secretKey: 'foo' };

    expect(Account.hash()).to.equal('9ef39f8b577cd867b2173e450e2cb30542cc1d98');
  });

  it('returns null if localStorage is empty', () => {
    global.localStorage = { };

    expect(Account.hash()).to.equal(null);
  });

  it('returns the initial account', () => {
    Date.now = () => 1457409506204;

    global.localStorage = { publicKey: '6393a821af08e151399a8df339d02a9e36134b3da5f893849673cf176810eb98', secretKey: 'foo' };

    expect(Account.initialAccount()).to.deep.equal({ head: { hash: '9ef39f8b577cd867b2173e450e2cb30542cc1d98', d: 1457409506204, next: [], f: [] }, tweets: [], followBlocks: [] });
  });

  it('creates keys with hash', () => {
    global.localStorage = {};

    let keysWithHash = Account.createKeysWithHash();
    let hash = keysWithHash[0];
    let { publicKey, secretKey } = keysWithHash[1];

    expect(hash).to.be.a('string');
    expect(hash.length).to.equal(40);

    expect(publicKey).to.be.a('string');
    expect(publicKey.length).to.equal(64);

    expect(secretKey).to.be.a('string');
    expect(secretKey.length).to.equal(128);
  });
});
