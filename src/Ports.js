import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';
import { publish } from './Api/Publish';

export const setup = ({ requestAddTweet, dataStream, requestPublishHead, publishStream }) => {
  dataStream.send(initialData());

  requestAddTweet.subscribe(({data, text}) => {
    const newData = Tweets.add(hash(), data)(text);

    dataStream.send(newData);
  });

  requestPublishHead.subscribe((item) => {
    publish(item, (err, data) => {
      publishStream.send(data);
    });
  });
};

export default { setup };
