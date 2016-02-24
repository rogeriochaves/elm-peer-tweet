import { expect } from 'chai';

import { initializeAccount, accountHash } from '../../src/Api/DhtStore';

describe('DhtStore', () => {
  it('creates key if it is not there', () => {
    global.localStorage = {};

    initializeAccount();

    expect(global.localStorage.publicKey).to.be.a('string');
    expect(global.localStorage.publicKey.length).to.equal(64);

    expect(global.localStorage.secretKey).to.be.a('string');
    expect(global.localStorage.secretKey.length).to.equal(128);
  });

  it('does not creates key if it is already there', () => {
    global.localStorage = { publicKey: 'foo', secretKey: 'bar' };

    initializeAccount();

    expect(global.localStorage.publicKey).to.equal('foo');
    expect(global.localStorage.secretKey).to.equal('bar');
  });

  it('returns the right account hash', () => {
    global.localStorage = { publicKey: '6393a821af08e151399a8df339d02a9e36134b3da5f893849673cf176810eb98', secretKey: 'foo' };

    expect(accountHash()).to.equal('9ef39f8b577cd867b2173e450e2cb30542cc1d98');
  });
});
