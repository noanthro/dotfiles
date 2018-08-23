function! MyCallback(channel, msg)
	call append(line('$'),a:msg) 
	normal G
endfunction

function! MyCloseHandler(channel)
	set filetype=javascript
	wincmd p
endfunction

function! Focus(bufname)
  let bufmap = map(range(1, winnr('$')), '[bufname(winbufnr(v:val)), v:val]')
  let thewindow = filter(bufmap, 'v:val[0] =~ a:bufname')[0][1]
  execute thewindow 'wincmd w'
endfunction

function! Start(p, ...)
	let program = a:p
	if (a:0) && (program == 'node')
		let command = 'node -e "' . a:1 . '"'
	elseif (a:0) && (program == 'bash')
		let command = 'bash -c "' . a:1 . '"'
	else 
		write!
		let scriptpath = expand('%:p')
		let command = program . " " . scriptpath
	endif

	let nroutput = bufwinnr('nodeoutput')
	if (nroutput > 0) 
		call Focus("nodeoutput")	
		1,$d
	else	
		vsplit	
		edit nodeoutput
	endif

	let options={'callback':'MyCallback','close_cb':'MyCloseHandler'}
	let nodejob = job_start(command, options)
endfunction

nmap <Leader>v :call Start('node')<CR>
vmap <Leader>v "cy<ESC>:call Start('node',expand(@c))<CR>
nmap <Leader>b :call Start('bash')<CR>
vmap <Leader>b "by<ESC>:call Start('bash',expand(@b))<CR> 
