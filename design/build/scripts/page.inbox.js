(function() {
  var Inbox;

  Inbox = {
    element: null,
    events: {
      searchTimeoutInstance: null,
      lastSearchKeyword: '',
      fullViewToggle: function(e) {
        e.preventDefault();
        $(e.currentTarget).parent().toggleClass('active');
        $('div.messages > div.row').toggleClass('full-width');
        return null;
      },
      folderOnClick: function(e) {
        var folder;
        e.preventDefault();
        folder = $(e.currentTarget).attr('data-folder');
        folder = folder.toLowerCase();
        Inbox.Folder.open(folder);
        return null;
      },
      messageOnClick: function(e) {
        var id;
        e.preventDefault();
        id = $(e.currentTarget).attr('data-id');
        return Inbox.Message.open(id);
      },
      messageOnActionDeleteClick: function(e) {
        var id;
        e.preventDefault();
        e.stopPropagation();
        id = $(e.currentTarget).closest('ul.items > li[data-id]').attr('data-id');
        return Inbox.Message.remove(id);
      },
      messageOnActionReplyClick: function(e) {
        return null;
      },
      sortInputOnChange: function(e) {
        console.log(e);
        return null;
      },
      searchInputOnKeyDown: function(e) {
        var keyword;
        keyword = $(e.currentTarget).val();
        if (keyword !== this.lastSearchKeyword) {
          clearTimeout(this.searchTimeoutInstance);
          this.searchTimeoutInstance = setTimeout(function() {
            return Inbox.Message.search(keyword);
          }, 400);
        }
        this.lastSearchKeyword = keyword;
        return null;
      }
    },
    Folder: {
      open: function(folder) {
        switch (folder) {
          case 'inbox':
          case 'sent':
          case 'read':
          case 'unread':
            this.setActive(folder);
            $(Inbox.element).find('input.search-input').val('');
            console.log("folder '" + folder + "' opened!");
            return true;
          case 'search':
            return Inbox.Message.search();
          default:
            console.log("folder '" + folder + "' not found!");
            return false;
        }
      },
      setActive: function(folder) {
        $(Inbox.element).find('ul.folders > li[data-folder]').removeClass('active').end().find("ul.folders > li[data-folder='" + folder + "']").addClass('active');
        return null;
      }
    },
    Message: {
      open: function(id) {
        this.setActive(id);
        return console.log("message '" + id + "' opened");
      },
      remove: function(id) {
        $(Inbox.element).find("ul.items > li[data-id='" + id + "'] ul.actions").hide();
        return $(Inbox.element).find("ul.items > li[data-id='" + id + "'] > a").slideUp('fast', function() {
          return $(this).parent().remove();
        });
      },
      search: function(keyword) {
        Inbox.Folder.setActive('search');
        if (typeof keyword === 'undefined') {
          keyword = $(Inbox.element).find('input.search-input').val();
        }
        $(Inbox.element).find('ul.items').empty();
        return console.log("search for keyword '" + keyword + "'");
      },
      setActive: function(id) {
        return $(Inbox.element).find("ul.items > li[data-id]").removeClass('active').end().find("ul.items > li[data-id='" + id + "']").addClass('active');
      },
      setPreview: function(content) {
        return $(Inbox.element).find('div.preview').empty().append($(content));
      }
    },
    updateMessagesScrollbar: function() {
      return null;
    },
    init: function(e) {
      this.element = $(e);
      $(this.element).find('a#full-view-toggle').click(this.events.fullViewToggle);
      $(this.element).delegate('ul.folders > li[data-folder]', 'click', this.events.folderOnClick);
      $(this.element).delegate('ul.items > li[data-id]', 'click', this.events.messageOnClick).delegate('ul.items > li[data-id] ul.actions > li[data-action="delete"] > a', 'click', this.events.messageOnActionDeleteClick);
      $(this.element).find('select.sort-input').change(this.events.sortInputOnChange);
      $(this.element).find('input.search-input').keyup(this.events.searchInputOnKeyDown);
      return null;
    }
  };

  window.Inbox = Inbox;

  $(document).ready(function() {
    return Inbox.init('section.content div.messages');
  });

}).call(this);
