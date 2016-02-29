import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';

export const setup = ({ setData, requestAddTweet, requestDataSync }) => {
  setData.send(initialData());

  requestAddTweet.subscribe(({data, text}) => {
    const newData = Tweets.add(hash(), data)(text);

    setData.send(newData);
  });

  requestDataSync.subscribe((data) => {
    console.log('Data sync!', data);
  });
};

export default { setup };
