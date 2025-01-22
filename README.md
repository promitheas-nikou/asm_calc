# asm_calc
I had practically no experience doing really bare metal low level code for embedded systems, so I thought this was a great opportunity to learn some classic assembly!

I made a quick little calculator app (well I couldn't make a big one because there is a size limit :/) but I think I did a half decent job. It was my first time writing assembly myself and not copy-pasting others work so I'm half proud of myself...

It does addition, multiplication, subtraction, division (integer division, remainder gets dropped). Press enter to quit. Other thank that it should be good!

I made this for x64 Linux. In case somebody wants to try this out, keep in mind there *is* a difference between 64 and 32 bit linux, and even the source needs changes (different syscalls).
