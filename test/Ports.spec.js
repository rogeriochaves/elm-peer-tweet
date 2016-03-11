import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  let ports, requestAddTweet, requestAddFollower, receivedAccount, requestPublishHead, receivedPublishHead, requestPublishTweet, receivedPublishTweet,
    requestDownloadHead, receivedDownloadHead, requestDownloadTweet, receivedDownloadTweet;

  beforeEach(() => {
    global.localStorage = {
      publicKey: '1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167',
      secretKey: 'b80cb5444cd32ca171381244bc34fe0950740cbbd4c9c7eee7730822071382588cb57de6a8d71a1d48e7290061eb667be454986ca0b8553599abaa43761fb9a4'
    };

    Ports.__Rewire__('initialAccount', () => 'initialAccount');
    Ports.__Rewire__('publish', (item, fn) => fn(null, item));
    Ports.__Rewire__('download', (hash, fn) => fn(null, { hash: hash } ));

    ports = {
      requestAddTweet: {
        subscribe: (fn) => { requestAddTweet = fn }
      },
      requestAddFollower: {
        subscribe: (fn) => { requestAddFollower = fn }
      },
      accountStream: {
        send: (account) => { receivedAccount = account }
      },
      requestPublishHead: {
        subscribe: (fn) => { requestPublishHead = fn }
      },
      publishHeadStream: {
        send: (account) => { receivedPublishHead = account }
      },
      requestPublishTweet: {
        subscribe: (fn) => { requestPublishTweet = fn }
      },
      publishTweetStream: {
        send: (account) => { receivedPublishTweet = account }
      },
      requestDownloadHead: {
        subscribe: (fn) => { requestDownloadHead = fn }
      },
      downloadHeadStream: {
        send: (account) => { receivedDownloadHead = account }
      },
      requestDownloadTweet: {
        subscribe: (fn) => { requestDownloadTweet = fn }
      },
      downloadTweetStream: {
        send: (account) => { receivedDownloadTweet = account }
      }
    };
  });

  it('sets account as initial account on setup', () => {
    Ports.setup(ports);

    expect(receivedAccount).to.equal('initialAccount');
  });

  it('adds a tweet, sending the account back to the accountStream port', () => {
    Ports.setup(ports);

    Date.now = () => 1457409506204;

    requestAddTweet({ account: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(receivedAccount).to.deep.equal({
      head: { hash: 'myhash', d: 1457409506204, next: ['6048a8a05b82c3ad229e897788f339c02449660e'] },
      tweets: [
        { hash: '6048a8a05b82c3ad229e897788f339c02449660e', d: 1457409506204, t: 'hello world', next: [] }
      ]
    });
  });

  it('adds a follower, sending the account back to the accountStream port', () => {
    Ports.setup(ports);

    Date.now = () => 1457409506204;

    requestAddFollower({ account: { head: { hash: 'myhash', next: [], f: [] }, followBlocks: [] }, hash: '6048a8a05b82c3ad229e897788f339c02449660e' });

    expect(receivedAccount).to.deep.equal({
      head: { hash: 'myhash', d: 1457409506204, next: [], f: ['d703c79f640a8443d288e58d9f31dae2df4a3179'] },
      followBlocks: [
        { hash: 'd703c79f640a8443d288e58d9f31dae2df4a3179', l: ['6048a8a05b82c3ad229e897788f339c02449660e'], next: [] }
      ]
    });
  });

  it('publishes head, sending the hashes of account being published back', () => {
    Ports.setup(ports);

    requestPublishHead({ account: 'foo' });

    expect(receivedPublishHead).to.deep.equal({ account: 'foo' });
  });

  it('publishes tweet, sending the hashes of account being published back', () => {
    Ports.setup(ports);

    requestPublishTweet({ account: 'foo' });

    expect(receivedPublishTweet).to.deep.equal({ account: 'foo' });
  });

  it('downloads head, sending account back', () => {
    Ports.setup(ports);

    requestDownloadHead('foo');

    expect(receivedDownloadHead).to.deep.equal({ hash: 'foo' });
  });

  it('downloads tweet, sending account back', () => {
    Ports.setup(ports);

    requestDownloadTweet('bar');

    expect(receivedDownloadTweet).to.deep.equal({ hash: 'bar' });
  });
});
