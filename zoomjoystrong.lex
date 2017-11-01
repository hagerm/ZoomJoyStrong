/***********************************************************************
* Flex file to return valid tokens to the parser.                      *
*                                                                      *
* @author Matthew A, Hager                                             *
* @version October 31, 2017                                            *
***********************************************************************/

%{
        #include "zoomjoystrong.tab.h"

%}

%option noyywrap
%option yylineno

%%
end			    { return END; }
\;			    { return END_STATEMENT; }
point			{ return POINT; }
line			{ return LINE; }
circle			{ return CIRCLE; }
rectangle		{ return RECTANGLE; }
set_color		{ return SET_COLOR; }
[0-9]+          { yylval.iVal = atoi(yytext); return INT; }
[0-9]*\.[0-9]+	{ yylval.fVal = atof(yytext); return FLOAT; }
[" "]+|\t+|\n+	;
.			    { return ERROR; }

%%

/* No code needed here. */
