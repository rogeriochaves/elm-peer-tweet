import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';
import { publish } from './Api/Publish';

export const setup = (ports) => {
  const { requestAddTweet, dataStream,
          requestPublishHead, publishHeadStream,
          requestPublishTweet, publishTweetStream } = ports;

  dataStream.send(initialData());

  requestAddTweet.subscribe(({data, text}) => {
    const newData = Tweets.add(hash(), data)(text);

    dataStream.send(newData);
  });

  requestPublishHead.subscribe((item) => {
    publish(item, (err, data) => {
      publishHeadStream.send(data);
    });
  });

  requestPublishTweet.subscribe((item) => {
    publish(item, (err, data) => {
      publishTweetStream.send(data);
    });
  });
};

export default { setup };
