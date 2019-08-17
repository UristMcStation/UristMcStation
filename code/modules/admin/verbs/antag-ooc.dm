/client/verb/aooc(msg as text) //you don't exist, proc
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	sanitize_and_communicate(/decl/communication_channel/aooc, src, msg)