(function() {
  $(document).ready(function() {
    return $('button.button').click(function(e) {
      var callback, savingItem;
      e.preventDefault();
      savingItem = Alert.add('Saving your profile...', 'info');
      callback = function() {
        return Alert.update(savingItem, 'Saved!', 'note');
      };
      return setTimeout(callback, 5000);
    });
  });

}).call(this);
