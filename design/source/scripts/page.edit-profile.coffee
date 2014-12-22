$ document
	.ready () ->
		$ 'button.button'
			.click (e) ->
				e.preventDefault()
				savingItem = Alert.add 'Saving your profile...', 'info'
				callback = () ->
					Alert.update savingItem, 'Saved!', 'note'
				setTimeout callback, 5000