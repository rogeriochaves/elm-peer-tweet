import { expect } from 'chai';
import { spy } from 'sinon';
import Publish from '../../src/Api/Publish';

describe('Publish', () => {
  let dht, dhtPutData, callback, head, tweet;

  beforeEach(() => {
    dhtPutData = [];

    let dht = {
      put: (data, fn) => {
        dhtPutData.push(data);
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

    head = { hash: 'myhead', next: ['foo'] };
    tweet = { hash: 'foo', t: "hello it's me you are looking for?", next: ['bar'] };
    Publish.publish(head, callback);
    Publish.publish(tweet, callback);
  });

  it('calls the callback for the published tweet', () => {
    expect(callback.getCall(0).args[1]).to.equal('myhead');
    expect(callback.getCall(1).args[1]).to.equal('foo');
  });

  it('calls the callback without errors', () => {
    expect(callback.getCall(0).args[0]).to.equal(undefined);
    expect(callback.getCall(1).args[0]).to.equal(undefined);
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
    let opts = dhtPutData[0];

    expect(opts.k.toString('hex')).to.equal('1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167');
    expect(opts.sign('foo').toString('hex')).to.equal('1805a5a2f4246eedba3655a66e0dbe52e43d749cfe819bab7788e6c4e4d40f486604b7b2b275385050bbbeb1062cf7b234216d3c7144a8a6f57f502b56535c0b');
  });

  it('removes hash key for publishing', () => {
    expect(dhtPutData[0].v.hash).to.be.undefined;
    expect(dhtPutData[1].v.hash).to.be.undefined;
  });

  it('publishes tweets with the right text', () => {
    let tweetText = dhtPutData[1].v.t.toString();

    expect(tweetText).to.equal("hello it's me you are looking for?");
  });

  it('publishes the head and tweets with the right next hashes', () => {
    let headNext = dhtPutData[0].v.next.toString();
    let tweetNext = dhtPutData[1].v.next.toString();

    expect(headNext).to.equal('foo');
    expect(tweetNext).to.equal('bar');
  });
});
