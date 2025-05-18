
/proc/invalidate_file_cache()
	set name = "Invalidate File Cache"
	set category = "Debug Utility AI"

	FILEDATA_CACHE_INVALIDATE(1)
	to_chat(usr, "File Cache invalidated!")
