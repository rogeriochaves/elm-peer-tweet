Elm.Native.ConcatMap = {};
Elm.Native.ConcatMap.make = function (localRuntime) {
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.ConcatMap = localRuntime.Native.ConcatMap || {};

  if (!localRuntime.Native.ConcatMap.values) {
    var Signal = Elm.Native.Signal.make(localRuntime);
    var Task = Elm.Native.Task.make(localRuntime);

    // Timeout fix to stop runner from trying to use window.setTimeout when code is ran on node.js env
    window.setTimeout = setTimeout;

    var addNotifier = function (toSignal, fromSignal) {
      Signal.output("concatMap-listener-" + fromSignal.name + '-' + toSignal.name,
        function (value) {
          toSignal.notify((new Date()).getTime(), toSignal.id, value);
        }, fromSignal);

      return fromSignal.kids.length - 1;
    };

    var removeNotifier = function (signal, position) {
      signal.kids.splice(position, 1);
    };

    var concatMap = function (signalCreator) {
      return function (sourceSignal) {
        var concattedSignal = signalCreator(sourceSignal.value);
        var resultSignal = Signal.input('concatMap-' + sourceSignal.name + '-' + concattedSignal.name, concattedSignal.value);
        var notifierPosition = addNotifier(resultSignal, concattedSignal);

        Signal.output("concatMap-listener-" + sourceSignal.name,
          function (value) {
            removeNotifier(concattedSignal, notifierPosition);
            concattedSignal = signalCreator(value);
            notifierPosition = addNotifier(resultSignal, concattedSignal);

            resultSignal.notify((new Date()).getTime(), resultSignal.id, concattedSignal.value);
      		}, sourceSignal);

        return resultSignal;
      };
    };

    localRuntime.Native.ConcatMap.values = {
      concatMap: concatMap
    };
  }

  return localRuntime.Native.ConcatMap.values;
};
