﻿menu(where=sel.count>0 type='file|dir|drive|namespace|back' mode="multiple" title='File Manage' icon=\uE253)
{
	menu(mode="single" type='back' expanded=true)
	{
		menu(title='New Folder' icon=icon.new_folder)
		{
			item(title='DateTime' cmd=io.dir.create(sys.datetime("ymdHMSs")))
			item(title='Guid' cmd=io.dir.create(str.guid))
		}
		menu(title='New File' icon=icon.new_file)
		{
			var { dt = sys.datetime("ymdHMSs") }
			item(title='JS' cmd=io.file.create('@(dt).js', "const $ = document.querySelector.bind(document);\nconst $$ = document.querySelectorAll.bind(document);"))
			item(title='CSS' cmd=io.file.create('@(dt).css', "*,*::after,*::before{margin:0;padding:0;box-sizing:border-box}"))
			item(title='HTML' cmd=io.file.create('@(dt).html', "<html>\n\t<head>\n\t</head>\n\t<body>text_here\n\t</body>\n</html>"))
			item(title='XML' cmd=io.file.create('@(dt).xml', '<root>text_here</root>'))
			item(title='JSON' cmd=io.file.create('@(dt).json', '[]'))
			item(title='TXT' cmd=io.file.create('@(dt).txt', 'text_here'))
		}
	}
	menu(title=title.copy_path icon=icon.copy_path)
	{
		item(where=sel.count > 1 title='Copy (@sel.count) items selected' cmd=command.copy(sel(false, "\n")))
		item(mode="single" title=@sel.path tip=sel.path cmd=command.copy(sel.path))
		item(mode="single" type='file' sep="before" find='.lnk' title='open file location')
		sep
		item(mode="single" where=@sel.parent.len>3 title=sel.parent cmd=@command.copy(sel.parent))
		sep
		item(mode="single" type='file|dir|back.dir' title=sel.file.name cmd=command.copy(sel.file.name))
		item(mode="single" type='file' where=sel.file.len != sel.file.title.len title=@sel.file.title cmd=command.copy(sel.file.title))
		item(mode="single" type='file' where=sel.file.ext.len>0 title=sel.file.ext cmd=command.copy(sel.file.ext))
	}
	sep
	menu(sep="after" icon=\uE290 title=title.select)
	{
		item(title="All" icon=icon.select_all cmd=command.select_all)
		item(title="Invert" icon=icon.invert_selection cmd=command.invert_selection)
		item(title="None" icon=icon.select_none cmd=command.select_none)
	}
	item(type='file|dir|back.dir|drive' title='Take Ownership' icon=[\uE194,#f00] admin
		cmd args='/K takeown /f "@sel.path" @if(sel.type==1,null,"/r /d y") && icacls "@sel.path" /grant *S-1-5-32-544:F @if(sel.type==1,"/c /l","/t /c /l /q")')
	sep
	menu(title="Show/Hide" icon=icon.show_hidden_files)
	{
		item(title="System files" icon=inherit cmd='@command.togglehidden')
		item(title="File name extensions" icon=icon.show_file_extensions cmd='@command.toggleext')
	}
	menu(type='file|dir|back.dir' mode="single" title='Attributes')
	{
		var { atrr = io.attributes(sel.path) }
		item(title='Hidden' checked=io.attribute.hidden(atrr)
			cmd args='/c ATTRIB @if(io.attribute.hidden(atrr),"-","+")H "@sel.path"' window=hidden)
		
		item(title='System' checked=io.attribute.system(atrr)
			cmd args='/c ATTRIB @if(io.attribute.system(atrr),"-","+")S "@sel.path"' window=hidden)
			
		item(title='Read-Only' checked=io.attribute.readonly(atrr)
			cmd args='/c ATTRIB @if(io.attribute.readonly(atrr),"-","+")R "@sel.path"' window=hidden)
			
		item(title='Archive' checked=io.attribute.archive(atrr)
			cmd args='/c ATTRIB @if(io.attribute.archive(atrr),"-","+")A "@sel.path"' window=hidden)
		sep
		item(title="CREATED" keys=io.dt.created(sel.path, 'y/m/d') cmd=io.dt.created(sel.path,2000,1,1))
		item(title="MODIFIED" keys=io.dt.modified(sel.path, 'y/m/d') cmd=io.dt.modified(sel.path,2000,1,1))
		item(title="ACCESSED" keys=io.dt.accessed(sel.path, 'y/m/d') cmd=io.dt.accessed(sel.path,2000,1,1))
	}
	menu(mode="single" type='file' find='.dll|.ocx' sep="before" title='Register Server' icon=\uea86)
	{
		item(title='Register' admin cmd='regsvr32.exe' args='@sel.path.quote' invoke="multiple")
		item(title='Unregister' admin cmd='regsvr32.exe' args='/u @sel.path.quote' invoke="multiple")
	}
	item(where=!wnd.is_desktop title=title.folder_options icon=icon.folder_options cmd=command.folder_options)
}