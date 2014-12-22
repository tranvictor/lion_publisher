(function() {
  $(document).ready(function() {
    return $.ajax({
      method: 'get',
      url: 'articles.json',
      success: function(data, status, xhr) {
        if (typeof $.prototype.DataTable === 'function') {
          return $('#your-articles').DataTable({
            data: data,
            iDisplayLength: 12,
            aLengthMenu: [[12, 24, 36, 48, 96, -1], [12, 24, 36, 48, 96, 'All']],
            columns: [
              {
                data: 'id',
                title: 'ID',
                visible: false
              }, {
                data: 'thumbnail',
                title: 'Thumbnail'
              }, {
                data: 'title',
                title: 'Title',
                "class": 'info'
              }, {
                data: 'desc',
                title: 'Description',
                visible: false
              }, {
                data: 'published',
                title: 'Published',
                visible: false
              }, {
                "class": 'actions'
              }
            ],
            columnDefs: [
              {
                render: function(data, type, row) {
                  return '<a href=""><div class="image" style="background-image: url(' + 'http://192.168.1.160:3000/' + data + ')"></div></a>';
                },
                targets: 1
              }, {
                render: function(data, type, row) {
                  var publishedClass;
                  publishedClass = row.published === true ? 'published' : 'unpublished';
                  return '<h4 class="title"><a href="">' + data + '</a></h4>' + '<p class="' + publishedClass + '"></p>' + '<p class="description">' + row.desc + '</p>';
                },
                targets: 2
              }, {
                render: function(data, type, row) {
                  var changeStatusLabel, publishedClass;
                  publishedClass = row.published === true ? 'published' : 'unpublished';
                  changeStatusLabel = row.published === true ? 'Unpublish' : 'Publish';
                  return '<a href="" class="button"><i class="fa fa-globe space ' + publishedClass + '"></i>' + changeStatusLabel + '</a>' + '<a href="" class="button"><i class="fa fa-trash space"></i>Del</a>';
                },
                targets: 5
              }
            ]
          });
        }
      }
    });
  });

}).call(this);
