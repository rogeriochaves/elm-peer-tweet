import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  beforeEach(() => {
    Ports.__Rewire__('hash', () => 'myhash');
  });

  it('adds a tweet, sending the data back to the setData port', () => {
    let requestAddTweet, receivedData;

    Ports.setup({
      requestAddTweet: {
        subscribe: (fn) => { requestAddTweet = fn }
      },
      setData: {
        send: (data) => { receivedData = data }
      }
    });

    requestAddTweet({ data: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(receivedData).to.deep.equal({
      head: { hash: 'myhash', next: ['65131bd315f30324b0c0d6cbf2ccc058ea7523ec'] },
      tweets: [
        { hash: '65131bd315f30324b0c0d6cbf2ccc058ea7523ec', t: 'hello world', next: [] }
      ]
    });
  });
});
