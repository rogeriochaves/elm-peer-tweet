import { expect } from 'chai';
import { spy } from 'sinon';
import Publish from '../../src/Api/Publish';
import JSONB from 'json-buffer';

describe('Publish', () => {
  let dht, dhtPutData, callback, currentData;

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

    currentData = {
      'head': { hash: 'myhead', next: ['foo', 'bar'] },
      'tweets': [
        { hash: 'foo', t: 'you are looking for?', next: ['bar'] },
        { hash: 'bar', t: "hello it's me", next: [] }
      ]
    };
    Publish.publish(currentData, callback);
  });

  it('calls the callback for each item', () => {
    expect(callback.getCall(0).args[1]).to.equal('myhead');
    expect(callback.getCall(1).args[1]).to.equal('foo');
    expect(callback.getCall(2).args[1]).to.equal('bar');
  });

  it('calls the callback without errors', () => {
    expect(callback.getCall(0).args[0]).to.equal(undefined);
    expect(callback.getCall(1).args[0]).to.equal(undefined);
    expect(callback.getCall(2).args[0]).to.equal(undefined);
  });

  it('triggers the callback with an error when the dht gives an error', () => {
    callback.reset();

    Publish.__Rewire__('dht', {
      put: (_, fn) => fn('404 DOGE NOT FOUND')
    });
    Publish.publish(currentData, callback);

    expect(callback.getCall(0).args[0]).to.equal('404 DOGE NOT FOUND');
  });

  it('publishes the head with the right options', () => {
    let opts = dhtPutData[0].opts;

    expect(opts.k).to.equal('1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167');
    expect(opts.sign('foo').toString('hex')).to.equal('1805a5a2f4246eedba3655a66e0dbe52e43d749cfe819bab7788e6c4e4d40f486604b7b2b275385050bbbeb1062cf7b234216d3c7144a8a6f57f502b56535c0b');
  });

  it('publishes all the tweets recursively removing the hash key', () => {
    expect(dhtPutData[1].v.hash).to.be.undefined;
    expect(dhtPutData[2].v.hash).to.be.undefined;
  });

  it('publishes all the tweets recursively with the right text', () => {
    let tweetText1 = dhtPutData[1].v.t.toString();
    let tweetText2 = dhtPutData[2].v.t.toString();

    expect(tweetText1).to.equal('you are looking for?');
    expect(tweetText2).to.equal("hello it's me");
  });

  it('publishes the head and tweets with the right next hashes', () => {
    let headNext = dhtPutData[0].v.next.toString();
    let firstTweetNext = dhtPutData[1].v.next.toString();

    expect(headNext).to.equal('foobar');
    expect(firstTweetNext).to.equal('bar');
  });
});
