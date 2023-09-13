// #import "uniform"; not needed yet and may never be

parse_lit :: (token:Token,use:string) -> Expression {
            expr:Expression;
            if token.type == 254 {
                expr.Variable = LiteralExpr.{token.expr};
                return expr;
            }
            print("Invalid argument for % on line %",use,token.pos);
            exit(1);
            return expr;
}
parse_return :: (toks: [..] Token,it:int) -> Expression {
            expr:Expression;
            expr.Return = ReturnExpr.{parse_lit(toks[it + 1],"return").Variable};
            return expr;
}
#import "parser";
#import "lexer";
#import "Basic";