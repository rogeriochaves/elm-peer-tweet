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

    requestAddTweet({ data: {}, text: 'hello world' });

    expect(receivedData).to.deep.equal({
      'myhash': { next: ['7521867f54e7c67eff0b44294bec0f8628ae0086'] },
      '7521867f54e7c67eff0b44294bec0f8628ae0086': { t: 'hello world' }
    });
  });
});
