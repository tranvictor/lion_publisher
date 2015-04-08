(function() {
  if (typeof $.prototype.sortable === 'function' && typeof Dropzone !== 'undefined') {
    Dropzone.autoDiscover = false;
    $(document).ready(function() {
      var PageEditor;
      PageEditor = {
        pagesHolder: $('ul.pages'),
        thumbsHolder: $('ul.thumbs'),
        dropzone: null,
        events: {
          submit: function(e) {
            var index, page, pages, _i, _len;
            pages = $(PageEditor.pagesHolder).find('> li:not(.template)');
            for (index = _i = 0, _len = pages.length; _i < _len; index = ++_i) {
              page = pages[index];
              $(page).find('input[name="index"]').val(index);
            }
            return true;
          },
          thumbClick: function(e) {
            var index;
            index = $(e.currentTarget).closest('li').index();
            return PageEditor.showPage(index);
          },
          thumbsChanged: function(e) {
            return $(PageEditor.thumbsHolder).sortable('reload');
          },
          sortUpdate: function(e, ui) {
            var newIndex, oldIndex, pages;
            oldIndex = ui.oldindex;
            newIndex = ui.item.index();
            pages = $(PageEditor.pagesHolder).find('> li:not(.template)');
            window.pages = pages;
            if (oldIndex < newIndex) {
              $(pages).eq(oldIndex).insertAfter($(pages).eq(newIndex));
            } else {
              $(pages).eq(oldIndex).insertBefore($(pages).eq(newIndex));
            }
            PageEditor.showPage(newIndex);
            return PageEditor.reload();
          }
        },
        showPage: function(index) {
          $(PageEditor.thumbsHolder).find('> li').removeClass('active').eq(index).addClass('active');
          return $(PageEditor.pagesHolder).find('> li').removeClass('active').eq(index).addClass('active').find('div.index > input').val(index + 1);
        },
        reload: function() {
          return $(PageEditor.thumbsHolder).sortable('reload');
        },
        create: function(imageUrl, title, url, text) {
          var page, thumb;
          page = $(PageEditor.pagesHolder).find('> li.template').clone();
          $(page).find('td.image').css('background-image', 'url(' + imageUrl + ')');
          $(page).find('[name="title"]').val(title);
          $(page).find('[name="image-url"]').val(imageUrl);
          $(page).find('[name="image-source"]').val(url);
          $(page).find('[name="text"]').val(text);
          $(page).removeClass('template');
          $(PageEditor.pagesHolder).find('> li.template').before(page);
          thumb = $(PageEditor.thumbsHolder).find('> li.template').clone();
          $(thumb).find('.image').css('background-image', 'url(' + imageUrl + ')');
          $(thumb).removeClass('template');
          return $(PageEditor.thumbsHolder).find('> li.template').before(thumb);
        },
        remove: function(index) {
          $(PageEditor.thumbsHolder).find('> li').eq(index).remove();
          $(PageEditor.pagesHolder).find('> li:not(.template)').eq(index).remove();
          PageEditor.reload();
          return null;
        },
        serialize: function() {
          var description, imageSource, imageUrl, index, page, pages, position, results, title, _i, _len;
          results = [];
          pages = $(PageEditor.pagesHolder).find('> li:not(.template)');
          for (index = _i = 0, _len = pages.length; _i < _len; index = ++_i) {
            page = pages[index];
            position = index + 1;
            title = $(page).find('input#page-title').val();
            imageUrl = $(page).find('input#page-image-url').val();
            imageSource = $(page).find('input#page-image-source').val();
            description = $(page).find('textarea#page-description').val();
            results.push({
              position: position,
              title: title,
              imageUrl: imageUrl,
              imageSource: imageSource,
              description: description
            });
          }
          return results;
        },
        json: function() {
          return JSON.stringify(PageEditor.serialize());
        }
      };
      $(PageEditor.thumbsHolder).delegate('> li:not(.template) > div.image', 'click', PageEditor.events.thumbClick);
      $(PageEditor.thumbsHolder).sortable({
        handle: 'div.image',
        items: ':not(.template)',
        forcePlaceholderSize: false
      }).bind('sortupdate', PageEditor.events.sortUpdate);
      PageEditor.dropzone = new Dropzone($('#dropzone')[0], {
        paramName: 'file',
        maxFilesize: 2,
        parallelUploads: 10,
        uploadMultiple: false,
        thumbnailWidth: 480,
        thumbnailHeight: 320,
        dictDefaultMessage: '<i class="fa fa-cloud-upload space"></i>Drop or click to choose files for upload...',
        previewTemplate: '<div class="dz-preview dz-file-preview"> <div class="dz-details"> <div class="dz-filename left"><span data-dz-name></span></div> <div class="dz-size right"></div> <div class="clearfix"></div><img data-dz-thumbnail class="hide"> <div class="dz-progress progress"><span data-dz-uploadprogress class="dz-upload meter"></span></div> <div class="dz-success-mark hide"><span>✔</span></div> <div class="dz-error-mark hide"><span>✘</span></div> <div class="dz-error-message"><span data-dz-errormessage></span></div> </div> </div>',
        resize: function(file) {
          return null;
        },
        accept: function(file, done) {
          return done();
        },
        init: function() {
          this.on('addedfile', function(file) {});
          this.on('error', function(file, message) {
            return null;
          });
          this.on('success', function(file, response) {
            $(file.previewElement).fadeOut('slow', function() {
              PageEditor.create(response.raw);
              PageEditor.reload();
              return PageEditor.dropzone.removeFile(file);
            });
            return null;
          });
          this.on('uploadprogress', function(file, progress) {
            var bgColor;
            bgColor = '#f63a0f';
            if (progress <= 25) {
              bgColor = '#f27011';
            } else {
              if (progress <= 50) {
                bgColor = '#f2b01e';
              } else {
                if (progress <= 75) {
                  bgColor = '#f2d31b';
                } else {
                  if (progress <= 100) {
                    bgColor = '#86e01e';
                  }
                }
              }
            }
            return $(file.previewElement).find('.meter').css('background-color', bgColor);
          });
          this.on('thumbnail', function(file, dataUrl) {
            return null;
          });
          return this.on('complete', function(file) {
            PageEditor.events.thumbsChanged();
            return null;
          });
        }
      });
      window.PageEditor = PageEditor;
      return null;
    });
  }

}).call(this);
