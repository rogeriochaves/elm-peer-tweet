import { expect } from 'chai';

import { initializeAccount } from '../../src/Api/DhtStore';

describe('DhtStore', () => {
  it('creates key if it is not there', () => {
    global.localStorage = {};

    initializeAccount();

    expect(global.localStorage.publicKey).to.be.a('string');
    expect(global.localStorage.publicKey.length).to.equal(64);

    expect(global.localStorage.secretKey).to.be.a('string');
    expect(global.localStorage.secretKey.length).to.equal(128);
  });
});
