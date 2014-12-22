Inbox =

	element: null

	events:

		searchTimeoutInstance: null
		lastSearchKeyword: ''

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

		messageOnClick: (e) ->
			e.preventDefault()
			id = $(e.currentTarget).attr 'data-id'
			Inbox.Message.open id

		messageOnActionDeleteClick: (e) ->
			e.preventDefault()
			e.stopPropagation()
			id = $(e.currentTarget).closest('ul.items > li[data-id]').attr 'data-id'
			Inbox.Message.remove id

		messageOnActionReplyClick: (e) ->
			null

		sortInputOnChange: (e) ->
			console.log e
			null

		searchInputOnKeyDown: (e) ->
			keyword = $(e.currentTarget).val()
			unless keyword is @lastSearchKeyword
				clearTimeout @searchTimeoutInstance
				@searchTimeoutInstance = setTimeout () ->
					Inbox.Message.search keyword
				, 400
			@lastSearchKeyword = keyword
			null

	Folder:

		open: (folder) ->
			switch folder
				when 'inbox', 'sent', 'read', 'unread'
					@setActive folder
					$ Inbox.element
						.find 'input.search-input'
						.val('')
					console.log "folder '#{folder}' opened!"
					true
				when 'search'
					Inbox.Message.search()
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
				.slideUp 'fast', () ->
					$ this
						.parent()
						.remove()

		search: (keyword) ->
			Inbox.Folder.setActive 'search'
			if typeof keyword == 'undefined'
				keyword = $(Inbox.element).find('input.search-input').val()
			$ Inbox.element
				.find 'ul.items'
				.empty()
			console.log "search for keyword '#{keyword}'"

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

	updateMessagesScrollbar: () ->
		null

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

		# messages click bind
		$ @element
			.delegate 'ul.items > li[data-id]', 'click', @events.messageOnClick
			.delegate 'ul.items > li[data-id] ul.actions > li[data-action="delete"] > a', 'click', @events.messageOnActionDeleteClick

		# sort box
		$ @element
			.find 'select.sort-input'
			.change @events.sortInputOnChange

		# search box
		$ @element
			.find 'input.search-input'
			.keyup @events.searchInputOnKeyDown

		null

window.Inbox = Inbox
$ document
	.ready () ->

		# inbox component init
		Inbox.init 'section.content div.messages'
