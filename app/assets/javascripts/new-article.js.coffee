Dropzone.autoDiscover = false

$ document
.ready () ->

  Page =
    dropzone: null
    create: (imageUrl, title, url, text) ->
      page = $('ul.pages > li.template').clone()

      $(page).find('td.image').css 'background-image', 'url(' + imageUrl + ')'
      $(page).find('[name="title"]').val title
      $(page).find('[name="url"]').val url
      $(page).find('[name="text"]').val text
      $(page).removeClass 'template'
      .hide()
      $ 'ul.pages > li.template'
      .before page
      $(page).fadeIn()

  $ 'ul.pages'
  .sortable
    containerSelector: 'ul.pages'
    # tolerance: 100
    pullPlaceholder: false
    vertical: true
    handle: 'li:not(.template) td.image'
    onDragStart: (item, container, _super) ->
      unless container.options.drop
        item.clone().insertAfter item
        _super item

  Page.dropzone = new Dropzone $('#dropzone')[0],
    paramName: 'file'
    maxFilesize: 2
    uploadMultiple: false
    thumbnailWidth: 480
    thumbnailHeight: 320
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
    accept: (file, done) ->
      done()
    init: () ->
      this.on 'addedfile', (file) ->

      this.on 'error', (file, message) ->
        null
      this.on 'success', (file, response) ->
        $ file.previewElement
        .fadeOut 'slow', () ->
          Page.create response.raw
          Page.dropzone.removeFile file
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
        # Page.dropzone.removeAllFiles()
        null

  null

