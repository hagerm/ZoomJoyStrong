# 343-language-creation-flex-and-bison

This project is creating my own simple language to replace MS Paint.

Written by Matthew Hager with help from Professor Woodring's samples: https://github.com/irawoodring/343-language-creation-flex-and-bison.

Note to compile properly on EOS I used the following command:
gcc -o zjs zoomjoystrong.c lex.yy.c zoomjoystrong.tab.c -lSDL2 -lm -std=gnu99
