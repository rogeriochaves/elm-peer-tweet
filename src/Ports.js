import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';

export const setup = ({ setData, requestAddTweet }) => {
  setData.send(initialData());

  requestAddTweet.subscribe(({data, text}) => {
    const newData = Tweets.add(hash(), data)(text);

    setData.send(newData);
  });
};

export default { setup };
