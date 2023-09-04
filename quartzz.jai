#import "Basic";
#load "include/lexer.jai";


main :: () 
{
    lex:Lexer;
    lex.source = "return 0;";
    
    print("lol\n");
}

#run main();