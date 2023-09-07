#import "Basic";
#import "File";
#load "include/lexer.jai";


main :: () 
{
    args := get_command_line_arguments();
    file: string;
    if args.count > 1 {
        if !read_entire_file(args[1]) {
            exit(1);
        }
        else {
            file = read_entire_file(args[1]);
        }
    }
    else {
        print("Sorry you need to tell the compiler what to compile!\n");
        exit(1);
    }
    lex:Lexer;
    lex.source = file;
    lex.tokens = tokenize(lex.source);
    for 0..lex.tokens.count - 1 {
        print("%",lex.tokens[it]);
    }
}
