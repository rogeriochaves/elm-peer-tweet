import { expect } from 'chai';
import { spy } from 'sinon';
import Publish from '../../src/Api/Publish';

describe('Publish', () => {
  let dht, dhtPutAccount, callback, head, tweet, followBlock;

  beforeEach(() => {
    dhtPutAccount = [];

    let dht = {
      put: (account, fn) => {
        dhtPutAccount.push(account);
        fn();
      }
    };
    Publish.__Rewire__('dht', dht);
    Publish.__Rewire__('head', () => 'myhead');
    Publish.__Rewire__('getKeys', () => ({
      publicKey: '1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167',
      secretKey: 'b80cb5444cd32ca171381244bc34fe0950740cbbd4c9c7eee7730822071382588cb57de6a8d71a1d48e7290061eb667be454986ca0b8553599abaa43761fb9a4'
    }));

    callback = spy();

    head = { hash: 'myhead', d: 1457409506204, next: ['foo'], f: ['uno', 'quattro'] };
    tweet = { hash: 'foo', d: 2457409506204, t: "hello it's me you are looking for?", next: ['bar'] };
    followBlock = { hash: 'uno', d: 3457409506204, l: ['duo', 'tre'], next: ['quattro'] };

    Publish.publish(head, callback);
    Publish.publish(tweet, callback);
    Publish.publish(followBlock, callback);
  });

  it('calls the callback for the published tweet', () => {
    expect(callback.getCall(0).args[1]).to.equal('myhead');
    expect(callback.getCall(1).args[1]).to.equal('foo');
    expect(callback.getCall(2).args[1]).to.equal('uno');
  });

  it('calls the callback without errors', () => {
    expect(callback.getCall(0).args[0]).to.equal(undefined);
    expect(callback.getCall(1).args[0]).to.equal(undefined);
    expect(callback.getCall(2).args[0]).to.equal(undefined);
  });

  it('calls the callback with an error when the dht gives an error', () => {
    callback.reset();

    Publish.__Rewire__('dht', {
      put: (_, fn) => fn('404 DOGE NOT FOUND')
    });
    Publish.publish(tweet, callback);

    expect(callback.getCall(0).args[0]).to.equal('404 DOGE NOT FOUND');
  });

  it('publishes the head with the right options', () => {
    let opts = dhtPutAccount[0];

    expect(opts.k.toString('hex')).to.equal('1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167');
    expect(opts.sign('foo').toString('hex')).to.equal('1805a5a2f4246eedba3655a66e0dbe52e43d749cfe819bab7788e6c4e4d40f486604b7b2b275385050bbbeb1062cf7b234216d3c7144a8a6f57f502b56535c0b');
  });

  it('removes hash key for publishing', () => {
    expect(dhtPutAccount[0].v.hash).to.be.undefined;
    expect(dhtPutAccount[1].v.hash).to.be.undefined;
    expect(dhtPutAccount[2].v.hash).to.be.undefined;
  });

  it('publishes tweets with the right text', () => {
    let tweetText = dhtPutAccount[1].v.t.toString();

    expect(tweetText).to.equal("hello it's me you are looking for?");
  });

  it('publishes followBlock with the right hashes list', () => {
    let hashesList = dhtPutAccount[2].v.l.toString();

    expect(hashesList).to.equal('duotre');
  });

  it('publishes head with the right follow blocks hashes list', () => {
    let followBlocksHashesList = dhtPutAccount[0].v.f.toString();

    expect(followBlocksHashesList).to.equal('unoquattro');
  });

  it('publishes the head, tweets and followBlocks with the right next hashes', () => {
    let headNext = dhtPutAccount[0].v.next.toString();
    let tweetNext = dhtPutAccount[1].v.next.toString();
    let followBlockNext = dhtPutAccount[2].v.next.toString();

    expect(headNext).to.equal('foo');
    expect(tweetNext).to.equal('bar');
    expect(followBlockNext).to.equal('quattro');
  });

  it('publishes the head and tweets with the right timestamps', () => {
    let headTimestamp = dhtPutAccount[0].v.d.readIntBE(0, 6);
    let tweetTimestamp = dhtPutAccount[1].v.d.readIntBE(0, 6);

    expect(headTimestamp).to.equal(1457409506204);
    expect(tweetTimestamp).to.equal(2457409506204);
  });
});
