#import "Basic";
#load "include/lexer.jai";


main :: () 
{
    lex:Lexer;
    lex.source = "return 0;testing;lol";
    src := parse_string(lex.source);
    for 0..src.count - 1 {
        print("%\n",src[it]);
    }
    begin_descent(lex);
}

#run main();