Inbox =

  element: null

  events:

    fullViewToggle: (e) ->
      e.preventDefault()
      $ e.currentTarget
        .parent()
        .toggleClass 'active'
      $ 'div.messages > div.row'
        .toggleClass 'full-width'
      null

    folderOnClick: (e) ->
      e.preventDefault()
      folder = $(e.currentTarget).attr 'data-folder'
      folder = folder.toLowerCase()
      Inbox.Folder.open folder
      null

    messageOnFetch: (xhr, data, status) ->
      $('#message-preview').html(data)
      id = $(this).parent().attr 'data-id'
      Inbox.Message.open id

    messageOnActionDeleted: (xhr, data, status) ->
      console.log("got here")
      id = $(this).closest('ul.items > li[data-id]').attr 'data-id'
      Inbox.Message.remove id

  Folder:

    open: (folder) ->
      switch folder
        when 'inbox', 'sent'
          @setActive folder
          console.log "folder '#{folder}' opened!"
          true
        else
          console.log "folder '#{folder}' not found!"
          false

    setActive: (folder) ->
      $ Inbox.element
        .find 'ul.folders > li[data-folder]'
        .removeClass 'active'
        .end()
        .find "ul.folders > li[data-folder='#{folder}']"
        .addClass 'active'
      null

  Message:

    open: (id) ->
      @setActive id
      console.log "message '#{id}' opened"

    remove: (id) ->
      $ Inbox.element
        .find "ul.items > li[data-id='#{id}'] ul.actions"
        .hide()
      $ Inbox.element
        .find "ul.items > li[data-id='#{id}'] > a"
        .slideUp '500', () ->
          $ this
            .parent()
            .remove()

    setActive: (id) ->
      $ Inbox.element
        .find "ul.items > li[data-id]"
        .removeClass 'active'
        .end()
        .find "ul.items > li[data-id='#{id}']"
        .addClass 'active'

    setPreview: (content) ->
      $ Inbox.element
        .find 'div.preview'
        .empty()
        .append $(content)

  init: (e) ->

    # element instance holder
    @element = $ e

    # view toggle bind
    $ @element
      .find 'a#full-view-toggle'
      .click @events.fullViewToggle

    # folders click bind
    $ @element
      .delegate 'ul.folders > li[data-folder]', 'click', @events.folderOnClick

    # delete button ajax bind
    $ @element
      .find('ul.items > li[data-id] ul.actions > li[data-action="delete"] > a')
      .on 'ajax:success', @events.messageOnActionDeleted

    # message ajax bind
    $ @element
      .find('ul.items > li > a')
      .on 'ajax:success', @events.messageOnFetch
    null

$ document
  .ready () ->

    # inbox component init
    Inbox.init 'section.content div.messages'

window.Inbox = Inbox
