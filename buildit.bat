del intro.prg
c:\c64\tools\tmpx\tmpx.exe -i intro.asm -o intro.prg  
c:\c64\tools\exomizer\win32\exomizer.exe sfx $0810 intro.prg -o intro+.prg  -s "lsr $d011" -f "rol $d011" -x "lda $fb eor #$01 sta $fb beq skip inc $fc lda $fc and #$05 sta $d020 skip:"
c:\c64\tools\vice\x64sc.exe intro+.prg
