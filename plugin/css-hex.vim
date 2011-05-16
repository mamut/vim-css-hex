let s:HexColored = 0
let s:HexColors = []

au BufEnter *.css,*.scss call HexHighlight()
au InsertLeave *.css,*.scss call HexHighlight()
au CursorMoved *.css,*.scss call HexHighlight()
au CursorMovedI *.css,*.scss call HexHighlight()

function! HexHighlight()
    if has("gui_running")
        if s:HexColored == 1
            call ClearHexHighlight()
        endif
        let hexGroup = 4
        let lineNumber = 0
        while lineNumber <= line("$")
            let currentLine = getline(lineNumber)
            let hexLineMatch = 1
            while match(currentLine, '#\x\{6}', 0, hexLineMatch) != -1
                let hexMatch = matchstr(currentLine, '#\x\{6}', 0, hexLineMatch)
                let r = str2nr(strpart(hexMatch, 1, 2), 16)
                let g = str2nr(strpart(hexMatch, 3, 2), 16)
                let b = str2nr(strpart(hexMatch, 5, 2), 16)
                let brightness = sqrt(r*r + g*g + b*b)
                if brightness < 220
                    exe 'hi hexColor'.hexGroup.' guifg=#FFFFFF guibg='.hexMatch
                else
                    exe 'hi hexColor'.hexGroup.' guifg=#000000 guibg='.hexMatch
                endif
                exe 'let m = matchadd("hexColor'.hexGroup.'", "'.hexMatch.'", 25, '.hexGroup.')'
                let s:HexColors += ['hexColor'.hexGroup]
                let hexGroup += 1
                let hexLineMatch += 1
            endwhile
            while match(currentLine, '#\x\{3}', 0, hexLineMatch) != -1
                let hexMatch = matchstr(currentLine, '#\x\{3}', 0, hexLineMatch)
                let r = str2nr(strpart(hexMatch, 1, 1), 16)
                let g = str2nr(strpart(hexMatch, 2, 1), 16)
                let b = str2nr(strpart(hexMatch, 3, 1), 16)
                let brightness = 16*sqrt(r*r + g*g + b*b)
                if brightness < 220
                    exe 'hi hexColor'.hexGroup.' guifg=#FFFFFF guibg='.hexMatch
                else
                    exe 'hi hexColor'.hexGroup.' guifg=#000000 guibg='.hexMatch
                endif
                exe 'let m = matchadd("hexColor'.hexGroup.'", "'.hexMatch.'", 25, '.hexGroup.')'
                let s:HexColors += ['hexColor'.hexGroup]
                let hexGroup += 1
                let hexLineMatch += 1
            endwhile
            let lineNumber += 1
        endwhile
        unlet lineNumber hexGroup
        let s:HexColored = 1
    endif
endfunction

function! ClearHexHighlight()
    if s:HexColored == 1
         for hexColor in s:HexColors
             exe 'highlight clear '.hexColor
         endfor
         call clearmatches()
         let s:HexColored = 0
    endif
endfunction
