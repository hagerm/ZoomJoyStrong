/***********************************************************************
* The bison file to parse lines and check for valid code based on our  *
* definitions.                                                         *
*                                                                      *
* @author Matthew A. Hager                                             *
* @version October 31, 2017                                            *
***********************************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "zoomjoystrong.h"
    char * str;
    extern int yylineno;

    int yylex();
    int yyerror( const char *s);
    void lex_error();
    void point_matched(const int two, const int three);
    void line_matched(const int two, const int three, const int four,
				      const int five);
    void circle_matched(const int two, const int three, const int four);
    void rectangle_matched(const int two, const int three, 
                           const int four, const int five);
    void set_color_matched(const int two, const int three, 
                           const int four);

%}

%union {
    int iVal;
    float fVal;
    char* sVal;
}

%start program
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT
%token <sVal> ERROR

%%

program:            statement_list END END_STATEMENT
                        { finish(); }
                ;
statement_list:     statement
                |   statement statement_list
                ;
statement:          point
                |   line
                |   circle
                |   rectangle
                |   set_color
                |   END_STATEMENT
                |   ERROR
                        { lex_error(); }
                ;
point:              POINT INT INT END_STATEMENT
                        { point_matched($2, $3); }
                ;
line:               LINE INT INT INT INT END_STATEMENT
                        { line_matched($2, $3, $4, $5); }
                ;
circle:             CIRCLE INT INT INT END_STATEMENT
                        { circle_matched($2, $3, $4); }
                ;
rectangle:          RECTANGLE INT INT INT INT END_STATEMENT
                        { rectangle_matched($2, $3, $4, $5); }
                ;
set_color:          SET_COLOR INT INT INT END_STATEMENT
                        { set_color_matched($2, $3, $4); }
                ;

%%

/***********************************************************************
* Main function to start the graphics and parsing.                     *
***********************************************************************/
int main(int argc, char** argv){
    setup();
    yyparse();
    return 0;
}


/***********************************************************************
* The parsing error                                                    *
***********************************************************************/
int yyerror( const char * s){
    printf("Error happened at line %d \n", yylineno);
    return 1;
}

/***********************************************************************
* A custom error to track invalid tokens. Just allows for printing that*
* an error occured and then continue parsing.                          *
***********************************************************************/
void lex_error(){
    fprintf(stderr, "There was a invalid Token found.\n"); 
}

/***********************************************************************
* A function to call when the valid statement for a POINT call is      *
* found. Error checks for being inside the defined graphic screen.     *
***********************************************************************/
void point_matched(const int two, const int three){
    if( two > WIDTH || two < 0 || three > HEIGHT || three < 0){
        fprintf(stderr, "Point goes out of bounds. Dimensions "
                "are: %d x %d \n", WIDTH, HEIGHT);
    }
    else {
        point( two, three );
    }
}

/***********************************************************************
* A function to call when the valid statement for a LINE  function is  *
* found Error checks for being inside the defined graphic screen.      *
***********************************************************************/
void line_matched(const int two, const int three, const int four,
                  const int five){
    if( two > WIDTH || two < 0 || three > HEIGHT || three < 0 ||
            four > WIDTH || four < 0 || five > HEIGHT || five < 0)
    {
        fprintf(stderr, "ERR: The Line goes out of bounds. Dimensions "
                "are: %d x %d \n", WIDTH, HEIGHT);
    }
    else {
        line(two, three, four, five);
    }							                
}

/***********************************************************************
* A function to call when the valid statement for a CIRCLE function is *
* found. Error checks for bein inside the defined graphic screen.      *
***********************************************************************/
void circle_matched(const int two, const int three, const int four){
    if( two > WIDTH || two < 0 || three > HEIGHT || three < 0 || 
        two + four > WIDTH || two - four < 0 ||
        three + four > HEIGHT || three - four < 0 || four < 0)
    {
        fprintf(stderr, "ERR: Circle is out of bounds. Dimensions "
                "are: %d x %d \n", WIDTH, HEIGHT);
    }
    else {
        circle(two, three, four);
    }
}

/***********************************************************************
* A function to call when the valid statement for a RECTANGLE function *
* is found. Error checks for being inside the defined graphic screen.  *
***********************************************************************/
void rectangle_matched(const int two, const int three, const int four,
                       const int five){
    if( two > WIDTH || two < 0 || three > HEIGHT || three < 0 ||
        two + four > WIDTH || three + five > HEIGHT ||
   	    four < 0 || five < 0)
    {
        fprintf(stderr, "ERR: Rectangle goes out of bounds. Dimensions "
                "are: %d x %d \n", WIDTH, HEIGHT);
    }
    else {
        rectangle(two, three, four, five);
    }								                
}

/***********************************************************************
* A function to call with the valid statement for a SET_COLOR function *
* is found. Error checks for being in the color value range of RGB     *
***********************************************************************/
void set_color_matched(const int two, const int three, const int four){
    if( two > 255 || two < 0 || three > 255 || three < 0 || 
        four > 255 || four < 0 ){
        fprintf(stderr, "ERR: All INTS for set_color must be in "
                "range 0-255.\n");
    }
    else {
        set_color(two, three, four);
    }
}
