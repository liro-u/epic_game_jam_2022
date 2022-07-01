extends Node

signal notification_added(notification) # keep

func notify(title, content):
	# keep (for the moment)
	emit_signal("notification_added", {
		"title": title,
		"content": content
	})
