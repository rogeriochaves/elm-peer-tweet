Elm.Native.ConcatMap = {};
Elm.Native.ConcatMap.make = function (localRuntime) {
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.ConcatMap = localRuntime.Native.ConcatMap || {};

  if (!localRuntime.Native.ConcatMap.values) {
    var Signal = Elm.Native.Signal.make(localRuntime);
    var Task = Elm.Native.Task.make(localRuntime);

    // Timeout fix to stop test runner from trying to use window.setTimeout
    window.setTimeout = setTimeout;

    var concatMap = function (signalCreator) {
      return function (sourceSignal) {
        var concattedSignal = signalCreator(sourceSignal.value);
        var newSignal = Signal.input('concatMap-'+ sourceSignal.name, concattedSignal.value);
        var notifierPosition = null;

        var addNotifierToConcattedSignal = function () {
          notifierPosition = sourceSignal.kids.length;

          Signal.output("concattedSignal-concatMap-" + sourceSignal.name,
            function () {
              newSignal.notify((new Date()).getTime(), newSignal.id, concattedSignal.value);
            }, concattedSignal);
        };

        addNotifierToConcattedSignal();

        Signal.output("sourceSignal-concatMap-" + sourceSignal.name,
          function () {
            concattedSignal.kids.splice(notifierPosition - 1, 1); // clear previous notifier
            concattedSignal = signalCreator(sourceSignal.value);
            addNotifierToConcattedSignal();

            newSignal.notify((new Date()).getTime(), newSignal.id, concattedSignal.value);
      		}, sourceSignal);

        return newSignal;
      };
    };

    localRuntime.Native.ConcatMap.values = {
      concatMap: concatMap
    };
  }

  return localRuntime.Native.ConcatMap.values;
};
