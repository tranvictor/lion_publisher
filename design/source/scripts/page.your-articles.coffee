$ document
.ready ->
  $.ajax
    method: 'get',
    url: 'articles.json'
    success: (data, status, xhr) ->
      if typeof $.prototype.DataTable == 'function'
        $ '#your-articles'
          .DataTable
            data: data
            iDisplayLength: 12
            aLengthMenu: [
              [ 12, 24, 36, 48, 96, -1 ],
              [ 12, 24, 36, 48, 96, 'All']
            ]
            columns: [
              {
                data: 'id'
                title: 'ID'
                visible: false
              }
              {
                data: 'thumbnail'
                title: 'Thumbnail'
              }
              {
                data: 'title'
                title: 'Title'
                class: 'info'
              }
              {
                data: 'desc'
                title: 'Description'
                visible: false
              }
              {
                data: 'published'
                title: 'Published'
                visible: false
              }
              {
                class: 'actions'
              }
            ]
            columnDefs: [
              {
                render: (data, type, row) ->
                  '<a href=""><div class="image" style="background-image: url(' + 'http://192.168.1.160:3000/' +  data + ')"></div></a>'
                targets: 1
              }
              {
                render: (data, type, row) ->
                  publishedClass = if row.published == true then 'published' else 'unpublished'
                  '<h4 class="title"><a href="">' + data + '</a></h4>' + '<p class="' + publishedClass + '"></p>' + '<p class="description">' + row.desc + '</p>'
                targets: 2
              }
              {
                render: (data, type, row) ->
                  publishedClass = if row.published == true then 'published' else 'unpublished'
                  changeStatusLabel = if row.published == true then 'Unpublish' else 'Publish'
                  '<a href="" class="button"><i class="fa fa-globe space ' + publishedClass + '"></i>' + changeStatusLabel + '</a>' + '<a href="" class="button"><i class="fa fa-trash space"></i>Del</a>'
                targets: 5
              }
            ]