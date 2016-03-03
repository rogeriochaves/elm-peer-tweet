import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  let ports, requestAddTweet, receivedData, requestPublishHead, receivedPublishHead, requestPublishTweet, receivedPublishTweet;

  beforeEach(() => {
    global.localStorage = {
      publicKey: '1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167',
      secretKey: 'b80cb5444cd32ca171381244bc34fe0950740cbbd4c9c7eee7730822071382588cb57de6a8d71a1d48e7290061eb667be454986ca0b8553599abaa43761fb9a4'
    };

    Ports.__Rewire__('initialData', () => 'initialData');
    Ports.__Rewire__('publish', (item, fn) => fn(null, item));

    ports = {
      requestAddTweet: {
        subscribe: (fn) => { requestAddTweet = fn }
      },
      dataStream: {
        send: (data) => { receivedData = data }
      },
      requestPublishHead: {
        subscribe: (fn) => { requestPublishHead = fn }
      },
      publishHeadStream: {
        send: (data) => { receivedPublishHead = data }
      },
      requestPublishTweet: {
        subscribe: (fn) => { requestPublishTweet = fn }
      },
      publishTweetStream: {
        send: (data) => { receivedPublishTweet = data }
      }
    };
  });

  it('sets data as initial data on setup', () => {
    Ports.setup(ports);

    expect(receivedData).to.equal('initialData');
  });

  it('adds a tweet, sending the data back to the dataStream port', () => {
    Ports.setup(ports);

    requestAddTweet({ data: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(receivedData).to.deep.equal({
      head: { hash: 'myhash', next: ['dcbfa7a4332149de74822303ad05b1c77d0f72f0'] },
      tweets: [
        { hash: 'dcbfa7a4332149de74822303ad05b1c77d0f72f0', t: 'hello world', next: [] }
      ]
    });
  });

  it('publishes head, sending the hashes of data being published back', () => {
    Ports.setup(ports);

    requestPublishHead({ data: 'foo' });

    expect(receivedPublishHead).to.deep.equal({ data: 'foo' });
  });

  it('publishes tweet, sending the hashes of data being published back', () => {
    Ports.setup(ports);

    requestPublishTweet({ data: 'foo' });

    expect(receivedPublishTweet).to.deep.equal({ data: 'foo' });
  });
});
