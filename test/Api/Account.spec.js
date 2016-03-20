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

    expect(Account.initialAccount()).to.deep.equal({ head: { hash: '9ef39f8b577cd867b2173e450e2cb30542cc1d98', d: 1457409506204, next: [], f: [], n: "" }, tweets: [], followBlocks: [] });
  });

  it('creates keys with hash', () => {
    global.localStorage = {};

    let keysWithHash = Account.createKeysWithHash();
    let hash = keysWithHash.hash;
    let { publicKey, secretKey } = keysWithHash.keys;

    expect(hash).to.be.a('string');
    expect(hash.length).to.equal(40);

    expect(publicKey).to.be.a('string');
    expect(publicKey.length).to.equal(64);

    expect(secretKey).to.be.a('string');
    expect(secretKey.length).to.equal(128);
  });

  it('sets the keys on the localStorage, returning the hash', () => {
    let hash = Account.setKeys({publicKey: '4ab783316d341ebcfc4476fafb5d6b330faf61ece2932f77f82b08d9768da81a', secretKey: '08a3287eebbe8dada17052020d409e4e9c3974ba3722f913744a9b819650e0688d65631fdc1042bd22127dcd9ea69bd990af8d1eda378bb083d5fb76b60304cd'});

    let { publicKey, secretKey } = global.localStorage;

    expect(publicKey).to.equal('4ab783316d341ebcfc4476fafb5d6b330faf61ece2932f77f82b08d9768da81a');
    expect(secretKey).to.equal('08a3287eebbe8dada17052020d409e4e9c3974ba3722f913744a9b819650e0688d65631fdc1042bd22127dcd9ea69bd990af8d1eda378bb083d5fb76b60304cd');
    expect(hash).to.equal('61d323b6e262992538cc514c2d209deec0c519fe');
  });
});
