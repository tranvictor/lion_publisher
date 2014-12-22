Dropzone.autoDiscover = false

$ document
.ready () ->

  PageEditor =

    articleHolder: $('#edit-article')
    pagesHolder: $('ul.pages')
    thumbsHolder: $('ul.thumbs')
    fetcherHolder:
      form: $('#image-urls')
      textBox: $('#image-urls textarea')
      button: $('#image-urls button')
    dropzone: null

    events:

      submit: (e) ->
        pages = $(PageEditor.pagesHolder).find '> li:not(.template)'
        for page, index in pages
          $ page
          .find 'input[name="index"]'
          .val index
        true

      thumbClick: (e) ->
        index = $(e.currentTarget).closest('li').index()
        PageEditor.showPage index

      thumbsChanged: (e) ->
        $ PageEditor.thumbsHolder
          .sortable 'reload'

      sortUpdate: (e, ui) ->
        oldIndex = ui.oldindex
        newIndex = ui.item.index()
        pages = $(PageEditor.pagesHolder).find('> li:not(.template)')
        window.pages = pages
        if oldIndex < newIndex
          $ pages
            .eq oldIndex
            .insertAfter $(pages).eq(newIndex)
        else
          $ pages
            .eq oldIndex
            .insertBefore $(pages).eq(newIndex)
        PageEditor.showPage newIndex
        PageEditor.reload()

    showPage: (index) -> 
      $ PageEditor.thumbsHolder
        .find '> li'
        .removeClass 'active'
        .eq index
        .addClass 'active'
      $ PageEditor.pagesHolder
        .find '> li'
        .removeClass 'active'
        .eq index
        .addClass 'active'
        .find 'div.index > input'
        .attr 'value', index + 1

    reload: () ->
      pages = $(PageEditor.pagesHolder).find '> li:not(.template)'
      for page, index in pages
        $(page).find('#index').attr('value', index + 1)

      # thumbs
      $ PageEditor.thumbsHolder
        .sortable 'reload'

    create: (thumbnail_html, form_html) ->
      # clone and modify page
      page = $(form_html)
      $ PageEditor.pagesHolder
        .find '> li.template'
        .before page
      # clone and modify thumb
      thumb = $(thumbnail_html)
      $ PageEditor.thumbsHolder
        .find '> li.template'
        .before thumb

    remove: (index) ->
      # remove a thumb
      $ PageEditor.thumbsHolder
        .find '> li'
        .eq index
        .remove()
      #  remove a slider slide
      $ PageEditor.pagesHolder
        .find '> li:not(.template)'
        .eq index
        .remove()
      # reload
      PageEditor.reload()
      null

    fetchImages: () ->
      PageEditor.fetcherHolder.submit()

    serialize: () ->
      results = []
      pages = $(PageEditor.pagesHolder).find '> li:not(.template)'
      for page, index in pages
        position = index + 1
        title = $(page).find('input#page-title').val()
        imageSource = $(page).find('input#page-image-source').val()
        description = $(page).find('textarea#page-description').val()
        results.push
          position: position
          title: title
          imageUrl: imageUrl
          imageSource: imageSource
          description: description
      results

    json: () ->
      JSON.stringify PageEditor.serialize()

  # $ PageEditor.pagesHolder
  #   .delegate '> li:not(.template) form', 'submit', PageEditor.events.submit

  $ PageEditor.thumbsHolder
    .delegate '> li:not(.template) > div.image', 'click', PageEditor.events.thumbClick

  $ PageEditor.thumbsHolder
    .sortable
      handle: 'div.image'
      items: ':not(.template)'
      forcePlaceholderSize: false
    .bind 'sortupdate', PageEditor.events.sortUpdate

  PageEditor.fetcherHolder.form
    .on 'ajax:send', (xhr) ->
      PageEditor.fetcherHolder.button
        .html('<i class="fa fa-check space"></i>Fetching images...')
        .attr('disabled', 'disabled')
    .on 'ajax:success', (xhr, data, status) ->
      data.forEach (page) ->
        PageEditor.create page.thumbnail_html, page.form_html
        PageEditor.reload()
      PageEditor.fetcherHolder.textBox.val ""
    .on 'ajax:complete', (xhr, status) ->
      PageEditor.fetcherHolder.button
        .html('<i class="fa fa-check space"></i>Fetch').removeAttr('disabled')

  PageEditor.articleHolder
    .on 'ajax:send', (xhr) ->
      window.alertInstance = Alert.update(window.alertInstance, "Saving...", "info")
    .on 'ajax:success', (xhr, data, status) ->
      Alert.update(window.alertInstance, "Saved", "success")

  PageEditor.dropzone = new Dropzone $('#dropzone')[0],
    paramName: 'file'
    maxFilesize: 10
    parallelUploads: 10
    uploadMultiple: false
    thumbnailWidth: 480
    thumbnailHeight: 320
    dictDefaultMessage: '<i class="fa fa-cloud-upload space"></i>Drop or click to choose files for upload...'
    previewTemplate: '
      <div class="dz-preview dz-file-preview">
        <div class="dz-details">
          <div class="dz-filename left"><span data-dz-name></span></div>
          <div class="dz-size right"></div>
          <div class="clearfix"></div><img data-dz-thumbnail class="hide">
          <div class="dz-progress progress"><span data-dz-uploadprogress class="dz-upload meter"></span></div>
          <div class="dz-success-mark hide"><span>✔</span></div>
          <div class="dz-error-mark hide"><span>✘</span></div>
          <div class="dz-error-message"><span data-dz-errormessage></span></div>
        </div>
      </div>
    '
    resize: (file) ->
      null
    accept: (file, done) ->
      done()
    init: () ->
      this.on 'addedfile', (file) ->

      this.on 'error', (file, message) ->
        null
      this.on 'success', (file, response) ->
        $ file.previewElement
        .fadeOut 'slow', () ->
          PageEditor.create response[0].thumbnail_html, response[0].form_html
          PageEditor.reload()
          PageEditor.dropzone.removeFile file
        null
      this.on 'uploadprogress', (file, progress) ->
        bgColor = '#f63a0f'
        if progress <= 25
          bgColor = '#f27011'
        else
          if progress <= 50
            bgColor = '#f2b01e'
          else
            if progress <= 75
              bgColor = '#f2d31b'
            else
              if progress <= 100
                bgColor = '#86e01e'
        $ file.previewElement
        .find '.meter'
        .css 'background-color', bgColor

      this.on 'thumbnail', (file, dataUrl) ->
        null
      this.on 'complete', (file) ->
        PageEditor.events.thumbsChanged()
        null

  window.PageEditor = PageEditor

  null

