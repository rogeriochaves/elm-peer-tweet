import { hash } from './Api/Account';
import Tweets from './Api/Tweets';

export const setup = ({ setData, requestAddTweet }) => {
  requestAddTweet.subscribe(({data, text}) => {
    const newData = Tweets.add(hash(), data)(text);

    setData.send(newData);
  });
};

export default { setup };
